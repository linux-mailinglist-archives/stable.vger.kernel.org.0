Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13EB4B4733
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244286AbiBNJkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:40:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbiBNJjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:39:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFA16AA53;
        Mon, 14 Feb 2022 01:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5041EB80DC1;
        Mon, 14 Feb 2022 09:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66815C340E9;
        Mon, 14 Feb 2022 09:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831302;
        bh=cyfD6cAL+cJCHRXrkrEDDSE13jOiSFS77BO1c8qJ0Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2MwzyJNQC3bt04zHpGEFYtyLd8ulJAmZuRZWrDeko6kSBl8qdj5VeO6hkyLYCtEY
         M9ZSsC2Rr9XNQP318JlsRLTwKLGyO86H4ZzH+ibAwfVWLvESlP7qxUxxbP34hjeV9M
         N1/xvj0LsbBZCJ0e8PcnERcl9ELZctXOYygYZBlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Prabhath Sajeepa <psajeepa@purestorage.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Uday Shankar <ushankar@purestorage.com>
Subject: [PATCH 5.4 11/71] nvme: Fix parsing of ANA log page
Date:   Mon, 14 Feb 2022 10:25:39 +0100
Message-Id: <20220214092452.410238173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prabhath Sajeepa <psajeepa@purestorage.com>

commit 64fab7290dc3561729bbc1e35895a517eb2e549e upstream.

Check validity of offset into ANA log buffer before accessing
nvme_ana_group_desc. This check ensures the size of ANA log buffer >=
offset + sizeof(nvme_ana_group_desc)

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Prabhath Sajeepa <psajeepa@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -458,8 +458,14 @@ static int nvme_parse_ana_log(struct nvm
 
 	for (i = 0; i < le16_to_cpu(ctrl->ana_log_buf->ngrps); i++) {
 		struct nvme_ana_group_desc *desc = base + offset;
-		u32 nr_nsids = le32_to_cpu(desc->nnsids);
-		size_t nsid_buf_size = nr_nsids * sizeof(__le32);
+		u32 nr_nsids;
+		size_t nsid_buf_size;
+
+		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
+			return -EINVAL;
+
+		nr_nsids = le32_to_cpu(desc->nnsids);
+		nsid_buf_size = nr_nsids * sizeof(__le32);
 
 		if (WARN_ON_ONCE(desc->grpid == 0))
 			return -EINVAL;
@@ -479,8 +485,6 @@ static int nvme_parse_ana_log(struct nvm
 			return error;
 
 		offset += nsid_buf_size;
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
-			return -EINVAL;
 	}
 
 	return 0;


