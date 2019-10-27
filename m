Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FEDE67A7
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbfJ0VW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731868AbfJ0VW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B6FC205C9;
        Sun, 27 Oct 2019 21:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211377;
        bh=tXsBqKtu6vFAtUYWW+CWmag2N1dcGDkHT2k+n6PCjEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F33gSeVbtURuCdb8q1A3GrD3XQ/YYGD6a7jZEXLqsELgOczk91FWPBV379PZmQKBv
         tULBMox7tPE7Cc1nPcoLQRZnigSEo2TOzNpQQei8DToAynBmK8hBgIqF8WlWIq8gq8
         mjPLUXcjpRfyqrGrEB9r4cXx21yK5z+aH22FhrUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 128/197] drm/amdgpu/sdma5: fix mask value of POLL_REGMEM packet for pipe sync
Date:   Sun, 27 Oct 2019 22:00:46 +0100
Message-Id: <20191027203358.637745681@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

commit d12c50857c6edc1d18aa7a60c5a4d6d943137bc0 upstream.

sdma will hang once sequence number to be polled reaches 0x1000_0000

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1086,7 +1086,7 @@ static void sdma_v5_0_ring_emit_pipeline
 	amdgpu_ring_write(ring, addr & 0xfffffffc);
 	amdgpu_ring_write(ring, upper_32_bits(addr) & 0xffffffff);
 	amdgpu_ring_write(ring, seq); /* reference */
-	amdgpu_ring_write(ring, 0xfffffff); /* mask */
+	amdgpu_ring_write(ring, 0xffffffff); /* mask */
 	amdgpu_ring_write(ring, SDMA_PKT_POLL_REGMEM_DW5_RETRY_COUNT(0xfff) |
 			  SDMA_PKT_POLL_REGMEM_DW5_INTERVAL(4)); /* retry count, poll interval */
 }


