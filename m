Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9011E378344
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhEJKnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231681AbhEJKly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BB1361975;
        Mon, 10 May 2021 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642734;
        bh=qqlqCzerzvh1/3RjIAAAzj8A1mHi6ULH9C2BG+XgYeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7EBeEEr58jI6NhUQEtJjFv+Kai50G2NKqjkBbatgFTT5bawYt9wAmd2Yg/mwqgnf
         JnXztO16JruZuPZlA93GLDckgthNpkyIEYwC1b/oAa/8/oGNGOzrAyrcBnvCbzUlje
         SnjFqKEqjfOWy+DzI9UYZwJ4dB5qMDPjqCcJpAtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 029/299] mmc: uniphier-sd: Fix a resource leak in the remove function
Date:   Mon, 10 May 2021 12:17:06 +0200
Message-Id: <20210510102005.810779049@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit e29c84857e2d51aa017ce04284b962742fb97d9e upstream.

A 'tmio_mmc_host_free()' call is missing in the remove function, in order
to balance a 'tmio_mmc_host_alloc()' call in the probe.
This is done in the error handling path of the probe, but not in the remove
function.

Add the missing call.

Fixes: 3fd784f745dd ("mmc: uniphier-sd: add UniPhier SD/eMMC controller driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20210220142953.918608-1-christophe.jaillet@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/uniphier-sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/uniphier-sd.c
+++ b/drivers/mmc/host/uniphier-sd.c
@@ -661,6 +661,7 @@ static int uniphier_sd_remove(struct pla
 
 	tmio_mmc_host_remove(host);
 	uniphier_sd_clk_disable(host);
+	tmio_mmc_host_free(host);
 
 	return 0;
 }


