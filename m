Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6CFF7E5B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfKKSqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbfKKSqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A18820674;
        Mon, 11 Nov 2019 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497966;
        bh=xfEgfX5Tk17FlbuIssIAcm1s/tupxh1PPvYDHYPfdbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCYrGZuFNT47JX3EqmPac/sd/FpvHmgxMA6Uln9bqxT5x0wOLN18HS7tItaVpg4A4
         D0j3X/uCbP8NhnrW8dBIarTY06V+4bqaXN2qqNUNo262wjnqLPSHHDSWJhKdKTH9VF
         7CFAW8Jq89my35oFnhuSIimTJpAwA/xVlkosX+NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/125] iommu/amd: Apply the same IVRS IOAPIC workaround to Acer Aspire A315-41
Date:   Mon, 11 Nov 2019 19:29:08 +0100
Message-Id: <20191111181454.410104668@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ad3e8da2d422c63c13819a53d3c5ea9312cc0b9d ]

Acer Aspire A315-41 requires the very same workaround as the existing
quirk for Dell Latitude 5495.  Add the new entry for that.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1137799
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_quirks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/amd_iommu_quirks.c b/drivers/iommu/amd_iommu_quirks.c
index c235f79b7a200..5120ce4fdce32 100644
--- a/drivers/iommu/amd_iommu_quirks.c
+++ b/drivers/iommu/amd_iommu_quirks.c
@@ -73,6 +73,19 @@ static const struct dmi_system_id ivrs_quirks[] __initconst = {
 		},
 		.driver_data = (void *)&ivrs_ioapic_quirks[DELL_LATITUDE_5495],
 	},
+	{
+		/*
+		 * Acer Aspire A315-41 requires the very same workaround as
+		 * Dell Latitude 5495
+		 */
+		.callback = ivrs_ioapic_quirk_cb,
+		.ident = "Acer Aspire A315-41",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A315-41"),
+		},
+		.driver_data = (void *)&ivrs_ioapic_quirks[DELL_LATITUDE_5495],
+	},
 	{
 		.callback = ivrs_ioapic_quirk_cb,
 		.ident = "Lenovo ideapad 330S-15ARR",
-- 
2.20.1



