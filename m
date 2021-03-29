Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D6834CAAE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhC2Ije (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234146AbhC2IcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0663F61613;
        Mon, 29 Mar 2021 08:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006689;
        bh=ALWK2MgANjTNDoOXHTlGe4rZuzKW3+d/DbaMfhN1Co8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7Ph0YuIZhXe6EqxVt3L3NoctQLIraWGMKOokDQbMmTmPGNXn9DfcwnaXkp85HjB7
         fDAMDaWBlC7LxtyY7dzXohDDG8h3kt0w7G2JQ9XZcfdxoyzRnWA4q1uT2IivZ7Vzqb
         V3muowc0htq7y4MLwWvdEmwpZz8l/MFLRaFgmbAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 053/254] nvme-core: check ctrl css before setting up zns
Date:   Mon, 29 Mar 2021 09:56:09 +0200
Message-Id: <20210329075634.919919753@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 0ec84df4953bd42c6583a555773f1d4996a061eb ]

Ensure multiple Command Sets are supported before starting to setup a
ZNS namespace.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
[hch: move the check around a bit]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 206bf0a50487..c611a17e83f0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4069,6 +4069,12 @@ static void nvme_validate_or_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 				nsid);
 			break;
 		}
+		if (!nvme_multi_css(ctrl)) {
+			dev_warn(ctrl->device,
+				"command set not reported for nsid: %d\n",
+				ns->head->ns_id);
+			break;
+		}
 		nvme_alloc_ns(ctrl, nsid, &ids);
 		break;
 	default:
-- 
2.30.1



