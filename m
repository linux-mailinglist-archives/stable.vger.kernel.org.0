Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C651AC8C7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404578AbgDPPO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441663AbgDPNuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5316F22247;
        Thu, 16 Apr 2020 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044994;
        bh=d9pFvTfnO44VU4f05RrOD3sJL8UbpjbwLQHFV2pQFuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwgXW7xHP0uRTHdSXQhsStBZ5O0ha/a8ExBTeBc9/C1LMzZu+fhBtuFEbaeAu1nG8
         MBOSkIIwTFq5XXxN5azTka72p3h/EasnCJhAXSxcL8A4z+fBXzv06ewu14hKlvd3/e
         BwJUO0JrEjvPkkR+EHVcnQN3ouMJ41pT/yLqbnRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Liu <aaron.liu@amd.com>,
        Yuxian Dai <Yuxian.Dai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.4 187/232] drm/amdgpu: unify fw_write_wait for new gfx9 asics
Date:   Thu, 16 Apr 2020 15:24:41 +0200
Message-Id: <20200416131338.514465096@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Liu <aaron.liu@amd.com>

commit 2960758cce2310774de60bbbd8d6841d436c54d9 upstream.

Make the fw_write_wait default case true since presumably all new
gfx9 asics will have updated firmware. That is using unique WAIT_REG_MEM
packet with opration=1.

Signed-off-by: Aaron Liu <aaron.liu@amd.com>
Tested-by: Aaron Liu <aaron.liu@amd.com>
Tested-by: Yuxian Dai <Yuxian.Dai@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1026,6 +1026,8 @@ static void gfx_v9_0_check_fw_write_wait
 			adev->gfx.mec_fw_write_wait = true;
 		break;
 	default:
+		adev->gfx.me_fw_write_wait = true;
+		adev->gfx.mec_fw_write_wait = true;
 		break;
 	}
 }


