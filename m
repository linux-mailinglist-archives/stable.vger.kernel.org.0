Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D087F4F3148
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiDEI00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbiDEIT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575FF6D854;
        Tue,  5 Apr 2022 01:10:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 029E6B81B90;
        Tue,  5 Apr 2022 08:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D159C385A0;
        Tue,  5 Apr 2022 08:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146252;
        bh=98aCFofgFx1i2qmaGNmZ2Ir40iIRhlyna9C5ZXP/Y2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4k3OFyUnpC3GZFN1VAC/AMhGcm5lTjkCHDpVXsiMM0zNxgR8VyO40VFVIomXj+Q3
         RdpwrWmyG66VIVbhhklh+yQe3OAUNuL29MK28t+jzCPep/Z2ZRpAc1hX60DDQD7uuQ
         PkVh5IR8m17dPlggnnxtxhUFr121vvaGCRIz47cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0697/1126] selftests/bpf/test_lirc_mode2.sh: Exit with proper code
Date:   Tue,  5 Apr 2022 09:24:04 +0200
Message-Id: <20220405070428.068045446@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit ec80906b0fbd7be11e3e960813b977b1ffe5f8fe ]

When test_lirc_mode2_user exec failed, the test report failed but still
exit with 0. Fix it by exiting with an error code.

Another issue is for the LIRCDEV checking. With bash -n, we need to quote
the variable, or it will always be true. So if test_lirc_mode2_user was
not run, just exit with skip code.

Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220321024149.157861-1-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lirc_mode2.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lirc_mode2.sh b/tools/testing/selftests/bpf/test_lirc_mode2.sh
index ec4e15948e40..5252b91f48a1 100755
--- a/tools/testing/selftests/bpf/test_lirc_mode2.sh
+++ b/tools/testing/selftests/bpf/test_lirc_mode2.sh
@@ -3,6 +3,7 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+ret=$ksft_skip
 
 msg="skip all tests:"
 if [ $UID != 0 ]; then
@@ -25,7 +26,7 @@ do
 	fi
 done
 
-if [ -n $LIRCDEV ];
+if [ -n "$LIRCDEV" ];
 then
 	TYPE=lirc_mode2
 	./test_lirc_mode2_user $LIRCDEV $INPUTDEV
@@ -36,3 +37,5 @@ then
 		echo -e ${GREEN}"PASS: $TYPE"${NC}
 	fi
 fi
+
+exit $ret
-- 
2.34.1



