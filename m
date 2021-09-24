Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D05417458
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346262AbhIXNFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346151AbhIXNDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0172361242;
        Fri, 24 Sep 2021 12:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488093;
        bh=Qr7btXacdmuC0tkC2+1vrsY2FkbQiToXUxF9boUqRY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tw8Cbgs5cqB8cCknFgZ1wt2VlaKKVNY5KZ4j+HM4OrM3iXWLVzksHoCD2qvy2LoPo
         NR67PzoIHXH1opQ9rLU/2Bqw9HhF8E6iU5kX4xLj6+qqCYjirZ9++p0C0v80TxgpFg
         x+pfOJ6hel+Vd5DGHiEjNaAhexqqn2Hqq9Ab/oJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 082/100] drm/amd/display: Fix memory leak reported by coverity
Date:   Fri, 24 Sep 2021 14:44:31 +0200
Message-Id: <20210924124344.216283281@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 03388a347fe7cf7c3bdf68b0823ba316d177d470 ]

Free memory allocated if any of the previous allocations failed.

>>>     CID 1487129:  Resource leaks  (RESOURCE_LEAK)
>>>     Variable "vpg" going out of scope leaks the storage it points to.

Addresses-Coverity-ID: 1487129: ("Resource leaks")

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
index dc7823d23ba8..dd38796ba30a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -510,8 +510,12 @@ static struct stream_encoder *dcn303_stream_encoder_create(enum engine_id eng_id
 	vpg = dcn303_vpg_create(ctx, vpg_inst);
 	afmt = dcn303_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt)
+	if (!enc1 || !vpg || !afmt) {
+		kfree(enc1);
+		kfree(vpg);
+		kfree(afmt);
 		return NULL;
+	}
 
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios, eng_id, vpg, afmt, &stream_enc_regs[eng_id],
 			&se_shift, &se_mask);
-- 
2.33.0



