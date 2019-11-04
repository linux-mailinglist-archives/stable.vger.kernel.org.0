Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BBEEEE17
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390699AbfKDWLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390697AbfKDWLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:35 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F1BC205C9;
        Mon,  4 Nov 2019 22:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905494;
        bh=82Iwy/4pR8jTM/KNiRL/8URn/tQlaOBlPsmrF1+kfTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBwB63waYH3nr25XWx/eSS/fttDaTpRv9TAJnzuj4NCWVl3cbTfs+foEGzNj85vQz
         z5EcerIp5/85psBBydQHrWhzJQyLuVFDJ4/Vhlwcf3shbEzS08ZwQ1IlGZpAPBqlWw
         SmtwN+TJd9DuW3uVjPL0aYxtPfDWUVNWT9wl8Jlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chen gong <curry.gong@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 141/163] drm/amdgpu: Fix SDMA hang when performing VKexample test
Date:   Mon,  4 Nov 2019 22:45:31 +0100
Message-Id: <20191104212150.546790069@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chen gong <curry.gong@amd.com>

commit e5574f61e9d8274c49e9a5d943abde8e938d57e1 upstream.

VKexample test hang during Occlusion/SDMA/Varia runs.
Clear XNACK_WATERMK in reg SDMA0_UTCL1_WATERMK to fix this issue.

Signed-off-by: chen gong <curry.gong@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -159,6 +159,7 @@ static const struct soc15_reg_golden gol
 	SOC15_REG_GOLDEN_VALUE(SDMA0, 0, mmSDMA0_RLC7_RB_RPTR_ADDR_LO, 0xfffffffd, 0x00000001),
 	SOC15_REG_GOLDEN_VALUE(SDMA0, 0, mmSDMA0_RLC7_RB_WPTR_POLL_CNTL, 0xfffffff7, 0x00403000),
 	SOC15_REG_GOLDEN_VALUE(SDMA0, 0, mmSDMA0_UTCL1_PAGE, 0x000003ff, 0x000003c0),
+	SOC15_REG_GOLDEN_VALUE(SDMA0, 0, mmSDMA0_UTCL1_WATERMK, 0xfc000000, 0x00000000)
 };
 
 static const struct soc15_reg_golden golden_settings_sdma1_4_2[] = {


