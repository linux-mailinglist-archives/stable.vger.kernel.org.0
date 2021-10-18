Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73A2431E82
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhJROBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhJRN75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE18061A53;
        Mon, 18 Oct 2021 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564523;
        bh=8pbmoMm1XhlbrHMxJD1caV5O4QJWhfMAtEFJXtpu3+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWzfQAh9i5asq743nKiLPOPCDj5AUMnzKIMXL3pXuj1hoebLNbf8NaEh6vVmF2HkT
         k/2LDPlO0Ycq0+/76xn8FUv/pQ/jr+Rm/610S82s5Iuf9iYNCNmAu9AosT+jkXpD7m
         3llMH3z4MBy3YoFN+B/1ggvv9zg9AlI8AunOZaaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 122/151] platform/mellanox: mlxreg-io: Fix read access of n-bytes size attributes
Date:   Mon, 18 Oct 2021 15:25:01 +0200
Message-Id: <20211018132344.639382497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

commit db9cc7d6f95e7d89b0ce57e785cfd9d67a7505d8 upstream.

Fix shift argument for function rol32(). It should be provided in bits,
while was provided in bytes.

Fixes: 86148190a7db ("platform/mellanox: mlxreg-io: Add support for complex attributes")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20210927142214.2613929-3-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mellanox/mlxreg-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/mellanox/mlxreg-io.c
+++ b/drivers/platform/mellanox/mlxreg-io.c
@@ -98,7 +98,7 @@ mlxreg_io_get_reg(void *regmap, struct m
 			if (ret)
 				goto access_error;
 
-			*regval |= rol32(val, regsize * i);
+			*regval |= rol32(val, regsize * i * 8);
 		}
 	}
 


