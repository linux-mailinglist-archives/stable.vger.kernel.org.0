Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F539603E08
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiJSJKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiJSJJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:09:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A908C72947;
        Wed, 19 Oct 2022 02:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00CCC6183C;
        Wed, 19 Oct 2022 09:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A9BC433D6;
        Wed, 19 Oct 2022 09:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170001;
        bh=Y9P6m1PbPCOui9z0QKgPu7ldnlI2rzx7ssJipzwrzGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQXSI8i9GY2F6EQxD1EsodiBqKX9jyT9hs8m7Jg5NN4m17QRp4LZV1FSdzSVrfYSB
         EMq8U1BSiaxIhafSog7RdrQ6WkzAzgIQJ4vpbQ36ov9g9yoBU/luRZbjRWdqMqJbPS
         lhEsye/wPspenfwRTlA27M5+VraPkiTi07YzMSo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 490/862] media: amphion: insert picture startcode after seek for vc1g format
Date:   Wed, 19 Oct 2022 10:29:37 +0200
Message-Id: <20221019083311.640131293@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit f7fd6c318c8a5d06bf3fe611f30763d62eaaf7f0 ]

For format vc1, the amphion vpu requires driver to
help insert some custom startcode before sequence and frame.
the startcode is different for vc1l and vc1g format.

But the sequence startcode is only needed at the beginning,
and it's not expected after seek.
driver need to treat the codec header and the first frame after seek
as a normal frame, and insert picture startcode for it.

In previous patch, I just fix it for vc1l format,
and should fix the similar issue for vc1g too.

Fixes: e670f5d672ef (media: amphion: only insert the first sequence startcode for vc1l format)
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_malone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index f4a488bf9880..51e0702f9ae1 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1293,7 +1293,7 @@ static int vpu_malone_insert_scode_vc1_g_pic(struct malone_scode_t *scode)
 	vbuf = to_vb2_v4l2_buffer(scode->vb);
 	data = vb2_plane_vaddr(scode->vb, 0);
 
-	if (vbuf->sequence == 0 || vpu_vb_is_codecconfig(vbuf))
+	if (scode->inst->total_input_count == 0 || vpu_vb_is_codecconfig(vbuf))
 		return 0;
 	if (MALONE_VC1_CONTAIN_NAL(*data))
 		return 0;
-- 
2.35.1



