Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3B58DEC3
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343869AbiHISXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346913AbiHISVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:21:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFFD30F78;
        Tue,  9 Aug 2022 11:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 914B9B81977;
        Tue,  9 Aug 2022 18:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D469AC4347C;
        Tue,  9 Aug 2022 18:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068429;
        bh=cAL7cSlopyAfoe9ePy3AVZXWDpqa/7WVl3RSZd8S3bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OL6pi+cxDpQiTWaTe9bg+6LAGKo2+1x6BA6L1nu6QJc//8SKMFZ0xRL9XN7v9joOj
         weuqS1xEgc2m6wA8EnAlYhTIUCS3GYzvM5AK4y+XD94n+cWcArw/JF646YcWdUZSvd
         BYmPWOIAwt52IhJMaf9sp/n83vNQDm77ll0864eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Klochkov <kdmitry556@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 16/35] tools/kvm_stat: fix display of error when multiple processes are found
Date:   Tue,  9 Aug 2022 20:00:45 +0200
Message-Id: <20220809175515.646168498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Klochkov <kdmitry556@gmail.com>

[ Upstream commit 933b5f9f98da29af646b51b36a0753692908ef64 ]

Instead of printing an error message, kvm_stat script fails when we
restrict statistics to a guest by its name and there are multiple guests
with such name:

  # kvm_stat -g my_vm
  Traceback (most recent call last):
    File "/usr/bin/kvm_stat", line 1819, in <module>
      main()
    File "/usr/bin/kvm_stat", line 1779, in main
      options = get_options()
    File "/usr/bin/kvm_stat", line 1718, in get_options
      options = argparser.parse_args()
    File "/usr/lib64/python3.10/argparse.py", line 1825, in parse_args
      args, argv = self.parse_known_args(args, namespace)
    File "/usr/lib64/python3.10/argparse.py", line 1858, in parse_known_args
      namespace, args = self._parse_known_args(args, namespace)
    File "/usr/lib64/python3.10/argparse.py", line 2067, in _parse_known_args
      start_index = consume_optional(start_index)
    File "/usr/lib64/python3.10/argparse.py", line 2007, in consume_optional
      take_action(action, args, option_string)
    File "/usr/lib64/python3.10/argparse.py", line 1935, in take_action
      action(self, namespace, argument_values, option_string)
    File "/usr/bin/kvm_stat", line 1649, in __call__
      ' to specify the desired pid'.format(" ".join(pids)))
  TypeError: sequence item 0: expected str instance, int found

To avoid this, it's needed to convert pids int values to strings before
pass them to join().

Signed-off-by: Dmitry Klochkov <kdmitry556@gmail.com>
Message-Id: <20220614121141.160689-1-kdmitry556@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/kvm/kvm_stat/kvm_stat | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 5a5bd74f55bd..9c366b3a676d 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1646,7 +1646,8 @@ Press any other key to refresh statistics immediately.
                          .format(values))
             if len(pids) > 1:
                 sys.exit('Error: Multiple processes found (pids: {}). Use "-p"'
-                         ' to specify the desired pid'.format(" ".join(pids)))
+                         ' to specify the desired pid'
+                         .format(" ".join(map(str, pids))))
             namespace.pid = pids[0]
 
     argparser = argparse.ArgumentParser(description=description_text,
-- 
2.35.1



