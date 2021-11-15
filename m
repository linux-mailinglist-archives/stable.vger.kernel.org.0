Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD5D450A8F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhKORLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:11:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232425AbhKORLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:11:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E13061452;
        Mon, 15 Nov 2021 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996096;
        bh=jhoe7c1eN62SxG3PeYQcb28iPTdAV4g9WevXUqpaico=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVyPBDdAPXB7FPjINV1RNqDriE7X514R8PvRowBUDFNI3YalKAsjkp4l3qAKSWD76
         a5QBjv/htmBLhePeB6JYSDOuvbrvRA7ALTNglNNjXj+zc6yZFWXj9QhlbZlriAJ7JT
         eyBUVKF3eS4BFzFtaiayM4Qb+xFrKXphWyJRsOEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 015/355] tpm: Check for integer overflow in tpm2_map_response_body()
Date:   Mon, 15 Nov 2021 17:58:59 +0100
Message-Id: <20211115165314.044647919@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a0bcce2b2a169e10eb265c8f0ebdd5ae4c875670 upstream.

The "4 * be32_to_cpu(data->count)" multiplication can potentially
overflow which would lead to memory corruption.  Add a check for that.

Cc: stable@vger.kernel.org
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-space.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -455,6 +455,9 @@ static int tpm2_map_response_body(struct
 	if (be32_to_cpu(data->capability) != TPM2_CAP_HANDLES)
 		return 0;
 
+	if (be32_to_cpu(data->count) > (UINT_MAX - TPM_HEADER_SIZE - 9) / 4)
+		return -EFAULT;
+
 	if (len != TPM_HEADER_SIZE + 9 + 4 * be32_to_cpu(data->count))
 		return -EFAULT;
 


