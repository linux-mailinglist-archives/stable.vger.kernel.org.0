Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2789E31147E
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhBEWHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232834AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2AE565023;
        Fri,  5 Feb 2021 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534279;
        bh=FKVHPlqgWZf6FB0yq4aTtFJ9KHS1p/HLMiToBk7OHlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aa/y1+JYuFiKfivfmjtQlG0FF7GWSyZynqQns+bHpQdIiAoiieicVEwh0PVNQX+Eb
         i5hxUIRDKBGAZVt8N5Utz6ikf6L2vPXC8+KK65yJrHy/5C+1YjB6IzZzMM2f6hB/hX
         xNsCMUxIoetpMyG2Ax/FsIUB1RP1TSCjfqKpVGWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/57] habanalabs: fix backward compatibility of idle check
Date:   Fri,  5 Feb 2021 15:07:18 +0100
Message-Id: <20210205140658.214219970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit f8abaf379bfe19600f96ae79a6759eb37039ae05 ]

Need to take the lower 32 bits of the driver's 64-bit idle mask and put
it in the legacy 32-bit variable that the userspace reads to know the
idle mask.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/habanalabs_ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index 07317ea491295..35401148969f5 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -133,6 +133,8 @@ static int hw_idle(struct hl_device *hdev, struct hl_info_args *args)
 
 	hw_idle.is_idle = hdev->asic_funcs->is_device_idle(hdev,
 					&hw_idle.busy_engines_mask_ext, NULL);
+	hw_idle.busy_engines_mask =
+			lower_32_bits(hw_idle.busy_engines_mask_ext);
 
 	return copy_to_user(out, &hw_idle,
 		min((size_t) max_size, sizeof(hw_idle))) ? -EFAULT : 0;
-- 
2.27.0



