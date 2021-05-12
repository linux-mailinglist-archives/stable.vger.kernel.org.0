Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F02137C7E7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhELQDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238238AbhELP5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB65F61CB5;
        Wed, 12 May 2021 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833473;
        bh=u4W7i3gyZnl0bLRQ1VqTxnjfjIG6nemVpNOiekuPU4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sorKC+1hpcMiW4A/NydBxpSDp3s8z2Da0O5FiLGp3G/OxlvZT/XaCQWjRTjc4e4b7
         87fVv7D0qXSbAvjpmw3S6K2yR0qOPeYwuRdl6jIyQorJAizkYY4PU3N1y3awMOJ30b
         HVfk1+ji8KlZ4DuLIrEva6Gp6NURMTPfer501yeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 163/601] mfd: intel_pmt: Fix nuisance messages and handling of disabled capabilities
Date:   Wed, 12 May 2021 16:44:00 +0200
Message-Id: <20210512144833.203413012@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit a1a5c1c3df282dc122508a17500317266ef19e46 ]

Some products will be available that have PMT capabilities that are not
supported. Remove the warnings in this instance to avoid nuisance messages
and confusion.

Also return an error code for capabilities that are disabled by quirk to
prevent them from keeping the driver loaded if only disabled capabilities
are found.

Fixes: 4f8217d5b0ca ("mfd: Intel Platform Monitoring Technology support")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_pmt.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/intel_pmt.c b/drivers/mfd/intel_pmt.c
index 744b230cdcca..65da2b17a204 100644
--- a/drivers/mfd/intel_pmt.c
+++ b/drivers/mfd/intel_pmt.c
@@ -79,19 +79,18 @@ static int pmt_add_dev(struct pci_dev *pdev, struct intel_dvsec_header *header,
 	case DVSEC_INTEL_ID_WATCHER:
 		if (quirks & PMT_QUIRK_NO_WATCHER) {
 			dev_info(dev, "Watcher not supported\n");
-			return 0;
+			return -EINVAL;
 		}
 		name = "pmt_watcher";
 		break;
 	case DVSEC_INTEL_ID_CRASHLOG:
 		if (quirks & PMT_QUIRK_NO_CRASHLOG) {
 			dev_info(dev, "Crashlog not supported\n");
-			return 0;
+			return -EINVAL;
 		}
 		name = "pmt_crashlog";
 		break;
 	default:
-		dev_err(dev, "Unrecognized PMT capability: %d\n", id);
 		return -EINVAL;
 	}
 
@@ -174,12 +173,8 @@ static int pmt_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		header.offset = INTEL_DVSEC_TABLE_OFFSET(table);
 
 		ret = pmt_add_dev(pdev, &header, quirks);
-		if (ret) {
-			dev_warn(&pdev->dev,
-				 "Failed to add device for DVSEC id %d\n",
-				 header.id);
+		if (ret)
 			continue;
-		}
 
 		found_devices = true;
 	} while (true);
-- 
2.30.2



