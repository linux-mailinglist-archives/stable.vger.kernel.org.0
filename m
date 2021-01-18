Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774962F9E5B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388912AbhARLht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390403AbhARLhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E439022ADC;
        Mon, 18 Jan 2021 11:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969793;
        bh=7qZctB+wVDZvRl3IuGRuLTWmXyJBRmOZJZw2yJV1oYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjGgkZV4vn/AuM+hX6jy5AIM8IvZwGzDhjii7zKx3429WJLFgp0PioIOiJR1VRo1u
         hC4spbNUq4O0/9P/g2DHNAMi6es4m0tZbDVK4moqlzIMV5gRk16o+mwfKHNdbX7rP3
         AAdsLrz+Cy4JXLXutKuqoYgy9G2KEKHx51d8jArc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 28/43] ASoC: Intel: fix error code cnl_set_dsp_D0()
Date:   Mon, 18 Jan 2021 12:34:51 +0100
Message-Id: <20210118113336.305611097@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
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
@@ -212,6 +212,7 @@ static int cnl_set_dsp_D0(struct sst_dsp
 				"dsp boot timeout, status=%#x error=%#x\n",
 				sst_dsp_shim_read(ctx, CNL_ADSP_FW_STATUS),
 				sst_dsp_shim_read(ctx, CNL_ADSP_ERROR_CODE));
+			ret = -ETIMEDOUT;
 			goto err;
 		}
 	} else {


