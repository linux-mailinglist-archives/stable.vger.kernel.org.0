Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F825676FB4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjAVPYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjAVPYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F172201A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F70E60C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8065C433D2;
        Sun, 22 Jan 2023 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401060;
        bh=rwBkHwuZlvnW+HjdscmqQ1DVruv9cfRmSD9EqjFf8wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vX7rgSHH/I6Wm5C7yXk+7nFOcQSPOGh/485IMhDXs8SFRWsYVnqaO5wLoF20wuX7Q
         9a+8M/7HOwcn81sxY+5hg8yuXym3NbLPn62vVuzw7Eoy2/MxRDthr8H8eTOeqnPXql
         O26LGo6kvtZjj/WDef1y9w88P5NehFUrByIHNH/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 093/193] thunderbolt: Do not report errors if on-board retimers are found
Date:   Sun, 22 Jan 2023 16:03:42 +0100
Message-Id: <20230122150250.610561840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

commit c28f3d80383571d3630df1a0e89500d23e855924 upstream.

Currently we return an error even if on-board retimers are found and
that's not expected. Fix this to return an error only if there was one
and 0 otherwise.

Fixes: 1e56c88adecc ("thunderbolt: Runtime resume USB4 port when retimers are scanned")
Cc: stable@vger.kernel.org
Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -471,10 +471,9 @@ int tb_retimer_scan(struct tb_port *port
 			break;
 	}
 
-	if (!last_idx) {
-		ret = 0;
+	ret = 0;
+	if (!last_idx)
 		goto out;
-	}
 
 	/* Add on-board retimers if they do not exist already */
 	for (i = 1; i <= last_idx; i++) {


