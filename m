Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34337D248F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389436AbfJJIrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389427AbfJJIrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D311E2064A;
        Thu, 10 Oct 2019 08:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697231;
        bh=XueAMMMjI+mRyFaJH7EeKgVF0OSCLCSbn9EDBMHy6V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1ctoF0p8VFmcrhUSrmSTfOONcNItc3aclDH83B/zyGJoIPIYKZbkLL676yJfJXsj
         nkLbXrru8CxW2zSRSsSUp7vCatGBKSxk4wm9FVwasYhjVWjegbZ8E4h+11pe5cBqAR
         HRCnc9hN/2wn9S/H5VmIeoPg6g4cC/mdVk2nnC5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 4.19 039/114] drm/nouveau/kms/nv50-: Dont create MSTMs for eDP connectors
Date:   Thu, 10 Oct 2019 10:35:46 +0200
Message-Id: <20191010083604.810310442@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 698c1aa9f83b618de79e9e5e19a58f70a4a6ae0f upstream.

On the ThinkPad P71, we have one eDP connector exposed along with 5 DP
connectors, resulting in a total of 11 TMDS encoders. Since the GPU on
this system is also capable of MST, we create an additional 4 fake MST
encoders for each DP port. Unfortunately, we also do this for the eDP
port as well, resulting in:

  1 eDP port: +1 TMDS encoder
              +4 DPMST encoders
  5 DP ports: +2 TMDS encoders
              +4 DPMST encoders
	      *5 ports
	      == 35 encoders

Which breaks things, since DRM has a hard coded limit of 32 encoders.
So, fix this by not creating MSTMs for any eDP connectors. This brings
us down to 31 encoders, although we can do better.

This fixes driver probing for nouveau on the ThinkPad P71.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -1517,7 +1517,8 @@ nv50_sor_create(struct drm_connector *co
 			nv_encoder->aux = aux;
 		}
 
-		if ((data = nvbios_dp_table(bios, &ver, &hdr, &cnt, &len)) &&
+		if (nv_connector->type != DCB_CONNECTOR_eDP &&
+		    (data = nvbios_dp_table(bios, &ver, &hdr, &cnt, &len)) &&
 		    ver >= 0x40 && (nvbios_rd08(bios, data + 0x08) & 0x04)) {
 			ret = nv50_mstm_new(nv_encoder, &nv_connector->aux, 16,
 					    nv_connector->base.base.id,


