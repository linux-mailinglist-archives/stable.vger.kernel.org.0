Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54BA33B7F1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhCOOBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232636AbhCON7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1FA64F43;
        Mon, 15 Mar 2021 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816774;
        bh=X8ky84fth5XNUMunG6WnkG97WsfMloHTJYQtQjZq/2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zj6RVdqAosKYl4CVt8s+PCwNZJ3lyEwhn/dgPGSqUsVueS92jHmRUP5JmOIbTp/Dm
         DuJyCBqabxQKXq3M10DDYAN0bcErA1OcqIl3wTcRnzp+PaAXvmjs1YfSfpzb1nhNXP
         Gognh98bfZXzJZd9HKSNssN5puHi/IkfdCDKTFkU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 117/306] media: rkisp1: params: fix wrong bits settings
Date:   Mon, 15 Mar 2021 14:53:00 +0100
Message-Id: <20210315135511.612613542@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

commit 2025a48cfd92d541c5ee47deee97f8a46d00c4ac upstream.

The histogram mode is set using 'rkisp1_params_set_bits'.
Only the bits of the mode should be the value argument for
that function. Otherwise bits outside the mode mask are
turned on which is not what was intended.

Fixes: bae1155cf579 ("media: staging: rkisp1: add output device for parameters")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-params.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -1288,7 +1288,6 @@ static void rkisp1_params_config_paramet
 	memset(hst.hist_weight, 0x01, sizeof(hst.hist_weight));
 	rkisp1_hst_config(params, &hst);
 	rkisp1_param_set_bits(params, RKISP1_CIF_ISP_HIST_PROP,
-			      ~RKISP1_CIF_ISP_HIST_PROP_MODE_MASK |
 			      rkisp1_hst_params_default_config.mode);
 
 	/* set the  range */


