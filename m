Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2633B7E0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhCOOBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhCON7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C04164D9E;
        Mon, 15 Mar 2021 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816768;
        bh=3J5T+51wExoyAnoz49/GEIY5eCDLm7DZch2NxfueNNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkUU095ikGmCx39s8+j9ySUC/A1M6hS92R9jfPII3SnHRW7KqrKfOD08qqbisQ7IS
         5ifNlp1Q2fI2oaOYHGhxqr7Of88j2xEupPiP+VkXkk9Dyz+dprogkHY5MI2AOcuqZ+
         LlMqTqmOzrhl1a0cyg+ZN0GXV5lfA6HeHYNoqgxI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 103/290] media: rkisp1: params: fix wrong bits settings
Date:   Mon, 15 Mar 2021 14:53:16 +0100
Message-Id: <20210315135545.396949680@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
 drivers/staging/media/rkisp1/rkisp1-params.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/media/rkisp1/rkisp1-params.c
+++ b/drivers/staging/media/rkisp1/rkisp1-params.c
@@ -1291,7 +1291,6 @@ static void rkisp1_params_config_paramet
 	memset(hst.hist_weight, 0x01, sizeof(hst.hist_weight));
 	rkisp1_hst_config(params, &hst);
 	rkisp1_param_set_bits(params, RKISP1_CIF_ISP_HIST_PROP,
-			      ~RKISP1_CIF_ISP_HIST_PROP_MODE_MASK |
 			      rkisp1_hst_params_default_config.mode);
 
 	/* set the  range */


