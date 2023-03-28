Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC26A6CC4C9
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbjC1PIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjC1PIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:08:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4EBE3AE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6836183C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8600C433EF;
        Tue, 28 Mar 2023 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016033;
        bh=PhObNGJPHGlYcK6PumO1SHpmmjeshhIaCthePBXbGTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxUle8D1cHUBsnBIzrl8dSlH6lApQt3G72WcOdNAhqBBfgFVL1PCHfQR3imGMdAij
         zgf/7Vmyxes4PSFl20mNRPfCRgUwXme5/xmuSvYr3PcFbdS3ePVH+7xJzntcbeTkTI
         bAf+KiODw8tX1v5qEC9pPGEqGEi7fT7b4ibB75j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heinz Wiesinger <pprkut@slackware.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/146] bootconfig: Fix testcase to increase max node
Date:   Tue, 28 Mar 2023 16:42:10 +0200
Message-Id: <20230328142604.414042044@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit b69245126a48e50882021180fa5d264dc7149ccc ]

Since commit 6c40624930c5 ("bootconfig: Increase max nodes of bootconfig
from 1024 to 8192 for DCC support") increased the max number of bootconfig
node to 8192, the bootconfig testcase of the max number of nodes fails.
To fix this issue, we can not simply increase the number in the test script
because the test bootconfig file becomes too big (>32KB). To fix that, we
can use a combination of three alphabets (26^3 = 17576). But with that,
we can not express the 8193 (just one exceed from the limitation) because
it also exceeds the max size of bootconfig. So, the first 26 nodes will just
use one alphabet.

With this fix, test-bootconfig.sh passes all tests.

Link: https://lore.kernel.org/all/167888844790.791176.670805252426835131.stgit@devnote2/

Reported-by: Heinz Wiesinger <pprkut@slackware.com>
Link: https://lore.kernel.org/all/2463802.XAFRqVoOGU@amaterasu.liwjatan.org
Fixes: 6c40624930c5 ("bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/test-bootconfig.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/bootconfig/test-bootconfig.sh b/tools/bootconfig/test-bootconfig.sh
index f68e2e9eef8b2..a2c484c243f5d 100755
--- a/tools/bootconfig/test-bootconfig.sh
+++ b/tools/bootconfig/test-bootconfig.sh
@@ -87,10 +87,14 @@ xfail grep -i "error" $OUTFILE
 
 echo "Max node number check"
 
-echo -n > $TEMPCONF
-for i in `seq 1 1024` ; do
-   echo "node$i" >> $TEMPCONF
-done
+awk '
+BEGIN {
+  for (i = 0; i < 26; i += 1)
+      printf("%c\n", 65 + i % 26)
+  for (i = 26; i < 8192; i += 1)
+      printf("%c%c%c\n", 65 + i % 26, 65 + (i / 26) % 26, 65 + (i / 26 / 26))
+}
+' > $TEMPCONF
 xpass $BOOTCONF -a $TEMPCONF $INITRD
 
 echo "badnode" >> $TEMPCONF
-- 
2.39.2



