Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2032E68D89E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjBGNLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjBGNKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:10:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B373B653
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 164A761408
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082A4C4339B;
        Tue,  7 Feb 2023 13:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775373;
        bh=ppPv8mMSl5LhMvNVuhVD3lzqsFermoPYvytexradPtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVc6D9HaakbFtfyckQKFc2dhcDicRJInVsGVXTLM7osjuO6ZqlZxv63Zdjc1lZgU0
         Fu/0Ez/pB4zXRhScuonaS8ydM6oWXkYhvQakXvyIYtQm13IMbhfzxNvtiNiD5WMuuI
         x98hciLQdpO2JMRvK+JZqrPNlPT+DyMY5fpESDic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/120] READ is "data destination", not source...
Date:   Tue,  7 Feb 2023 13:56:30 +0100
Message-Id: <20230207125619.587807819@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 355d2c2798e9dc39f6714fa7ef8902c0d4c5350b ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index c644617725a8..54eb6556c63d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -967,7 +967,7 @@ static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
 	refcount_set(&req->ref, 1);
 	req->mp_policy = clt_path->clt->mp_policy;
 
-	iov_iter_kvec(&iter, READ, vec, 1, usr_len);
+	iov_iter_kvec(&iter, WRITE, vec, 1, usr_len);
 	len = _copy_from_iter(req->iu->buf, usr_len, &iter);
 	WARN_ON(len != usr_len);
 
-- 
2.39.0



