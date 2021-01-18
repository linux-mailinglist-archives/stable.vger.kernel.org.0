Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C5B2FA292
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392506AbhAROIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390609AbhARLpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 759FF22CA1;
        Mon, 18 Jan 2021 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970286;
        bh=C9XGMfk0gs9HdsnikqlZFH5JaVQu/+ts9KzGxUw2k3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnEoHBUbeZi0llmVlkPcIRqS2z454zu8wXeYaCsNXHAAHuHvghu90FillMePa2SR+
         l/FSg7HMr5LnK4XbtAGI9lJ3X93552/UZGTrLWee3mxwdDesVoKod1aKhm3AotM6aN
         YOjpsp/CTqxbMNzLjgPis5983rggiEGOuebQgrL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 116/152] ASoC: Intel: fix error code cnl_set_dsp_D0()
Date:   Mon, 18 Jan 2021 12:34:51 +0100
Message-Id: <20210118113358.290808732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f373a811fd9a69fc8bafb9bcb41d2cfa36c62665 upstream.

Return -ETIMEDOUT if the dsp boot times out instead of returning
success.

Fixes: cb6a55284629 ("ASoC: Intel: cnl: Add sst library functions for cnl platform")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/X9NEvCzuN+IObnTN@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/skylake/cnl-sst.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/intel/skylake/cnl-sst.c
+++ b/sound/soc/intel/skylake/cnl-sst.c
@@ -224,6 +224,7 @@ static int cnl_set_dsp_D0(struct sst_dsp
 				"dsp boot timeout, status=%#x error=%#x\n",
 				sst_dsp_shim_read(ctx, CNL_ADSP_FW_STATUS),
 				sst_dsp_shim_read(ctx, CNL_ADSP_ERROR_CODE));
+			ret = -ETIMEDOUT;
 			goto err;
 		}
 	} else {


