Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FBA60AA49
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiJXNcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiJXNaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9F6ACA1D;
        Mon, 24 Oct 2022 05:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C2361253;
        Mon, 24 Oct 2022 12:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00613C433C1;
        Mon, 24 Oct 2022 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614573;
        bh=KwHi/Yz77vH5JpUvmQEm94H2dp2DiOF5mtJWc1mS1c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZNhZ3Iv9UOVknSDqrSkz1BqGsfCIp8aHDmcMom18AX7FcPo1/DHOM5sguaavMoXY
         WZJspw0Vw5rcou1mpUXHwMTa1ijv/cUrj1vqBwLxkucjpPjC11oEynyFivCsJE4n1Z
         eN5XHY60BNmJXH4kUw8L3FpO/wwoAGNSAa+sBlLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/390] kbuild: remove the target in signal traps when interrupted
Date:   Mon, 24 Oct 2022 13:31:22 +0200
Message-Id: <20221024113035.087700162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a7f3257da8a86b96fb9bf1bba40ae0bbd7f1885a ]

When receiving some signal, GNU Make automatically deletes the target if
it has already been changed by the interrupted recipe.

If the target is possibly incomplete due to interruption, it must be
deleted so that it will be remade from scratch on the next run of make.
Otherwise, the target would remain corrupted permanently because its
timestamp had already been updated.

Thanks to this behavior of Make, you can stop the build any time by
pressing Ctrl-C, and just run 'make' to resume it.

Kbuild also relies on this feature, but it is equivalently important
for any build systems that make decisions based on timestamps (if you
want to support Ctrl-C reliably).

However, this does not always work as claimed; Make immediately dies
with Ctrl-C if its stderr goes into a pipe.

  [Test Makefile]

    foo:
            echo hello > $@
            sleep 3
            echo world >> $@

  [Test Result]

    $ make                         # hit Ctrl-C
    echo hello > foo
    sleep 3
    ^Cmake: *** Deleting file 'foo'
    make: *** [Makefile:3: foo] Interrupt

    $ make 2>&1 | cat              # hit Ctrl-C
    echo hello > foo
    sleep 3
    ^C$                            # 'foo' is often left-over

The reason is because SIGINT is sent to the entire process group.
In this example, SIGINT kills 'cat', and 'make' writes the message to
the closed pipe, then dies with SIGPIPE before cleaning the target.

A typical bad scenario (as reported by [1], [2]) is to save build log
by using the 'tee' command:

    $ make 2>&1 | tee log

This can be problematic for any build systems based on Make, so I hope
it will be fixed in GNU Make. The maintainer of GNU Make stated this is
a long-standing issue and difficult to fix [3]. It has not been fixed
yet as of writing.

So, we cannot rely on Make cleaning the target. We can do it by
ourselves, in signal traps.

As far as I understand, Make takes care of SIGHUP, SIGINT, SIGQUIT, and
SITERM for the target removal. I added the traps for them, and also for
SIGPIPE just in case cmd_* rule prints something to stdout or stderr
(but I did not observe an actual case where SIGPIPE was triggered).

[Note 1]

The trap handler might be worth explaining.

    rm -f $@; trap - $(sig); kill -s $(sig) $$

This lets the shell kill itself by the signal it caught, so the parent
process can tell the child has exited on the signal. Generally, this is
a proper manner for handling signals, in case the calling program (like
Bash) may monitor WIFSIGNALED() and WTERMSIG() for WCE although this may
not be a big deal here because GNU Make handles SIGHUP, SIGINT, SIGQUIT
in WUE and SIGTERM in IUE.

  IUE - Immediate Unconditional Exit
  WUE - Wait and Unconditional Exit
  WCE - Wait and Cooperative Exit

For details, see "Proper handling of SIGINT/SIGQUIT" [4].

[Note 2]

Reverting 392885ee82d3 ("kbuild: let fixdep directly write to .*.cmd
files") would directly address [1], but it only saves if_changed_dep.
As reported in [2], all commands that use redirection can potentially
leave an empty (i.e. broken) target.

[Note 3]

Another (even safer) approach might be to always write to a temporary
file, and rename it to $@ at the end of the recipe.

   <command>  > $(tmp-target)
   mv $(tmp-target) $@

It would require a lot of Makefile changes, and result in ugly code,
so I did not take it.

[Note 4]

A little more thoughts about a pattern rule with multiple targets (or
a grouped target).

    %.x %.y: %.z
            <recipe>

When interrupted, GNU Make deletes both %.x and %.y, while this solution
only deletes $@. Probably, this is not a big deal. The next run of make
will execute the rule again to create $@ along with the other files.

[1]: https://lore.kernel.org/all/YLeot94yAaM4xbMY@gmail.com/
[2]: https://lore.kernel.org/all/20220510221333.2770571-1-robh@kernel.org/
[3]: https://lists.gnu.org/archive/html/help-make/2021-06/msg00001.html
[4]: https://www.cons.org/cracauer/sigint.html

Fixes: 392885ee82d3 ("kbuild: let fixdep directly write to .*.cmd files")
Reported-by: Ingo Molnar <mingo@kernel.org>
Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kbuild.include | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 0d6e11820791..25696de8114a 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -179,8 +179,29 @@ echo-cmd = $(if $($(quiet)cmd_$(1)),\
  quiet_redirect :=
 silent_redirect := exec >/dev/null;
 
+# Delete the target on interruption
+#
+# GNU Make automatically deletes the target if it has already been changed by
+# the interrupted recipe. So, you can safely stop the build by Ctrl-C (Make
+# will delete incomplete targets), and resume it later.
+#
+# However, this does not work when the stderr is piped to another program, like
+#  $ make >&2 | tee log
+# Make dies with SIGPIPE before cleaning the targets.
+#
+# To address it, we clean the target in signal traps.
+#
+# Make deletes the target when it catches SIGHUP, SIGINT, SIGQUIT, SIGTERM.
+# So, we cover them, and also SIGPIPE just in case.
+#
+# Of course, this is unneeded for phony targets.
+delete-on-interrupt = \
+	$(if $(filter-out $(PHONY), $@), \
+		$(foreach sig, HUP INT QUIT TERM PIPE, \
+			trap 'rm -f $@; trap - $(sig); kill -s $(sig) $$$$' $(sig);))
+
 # printing commands
-cmd = @set -e; $(echo-cmd) $($(quiet)redirect) $(cmd_$(1))
+cmd = @set -e; $(echo-cmd) $($(quiet)redirect) $(delete-on-interrupt) $(cmd_$(1))
 
 ###
 # if_changed      - execute command if any prerequisite is newer than
-- 
2.35.1



