Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB42C1F3BF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfEOK7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfEOK7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:59:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAABE216FD;
        Wed, 15 May 2019 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917983;
        bh=APERk5M5FEbChD90GwMBIzcU7qaUVL7l35l+cDgHsLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cld0labq1lhN4ICWx/O49EAVs9bTzE39A1h3Ls9sHvdJjoisewDSl4KOpsuLThXED
         Ilb+WuUP1JG7Xbzg6CklkgCns4a0/QpQYsjE/soYSjb6q6Qdmv6SL9rT7JMcZyjdgt
         HjAOskgv4aIEKMmlCzMpMjBaKSyInEtCN7+kSn8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Fertic <jeremyfertic@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 3.18 48/86] staging: iio: adt7316: allow adt751x to use internal vref for all dacs
Date:   Wed, 15 May 2019 12:55:25 +0200
Message-Id: <20190515090652.013389348@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Fertic <jeremyfertic@gmail.com>

commit 10bfe7cc1739c22f0aa296b39e53f61e9e3f4d99 upstream.

With adt7516/7/9, internal vref is available for dacs a and b, dacs c and
d, or all dacs. The driver doesn't currently support internal vref for all
dacs. Change the else if to an if so both bits are checked rather than
just one or the other.

Signed-off-by: Jeremy Fertic <jeremyfertic@gmail.com>
Fixes: 35f6b6b86ede ("staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/addac/adt7316.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -1092,7 +1092,7 @@ static ssize_t adt7316_store_DAC_interna
 		ldac_config = chip->ldac_config & (~ADT7516_DAC_IN_VREF_MASK);
 		if (data & 0x1)
 			ldac_config |= ADT7516_DAC_AB_IN_VREF;
-		else if (data & 0x2)
+		if (data & 0x2)
 			ldac_config |= ADT7516_DAC_CD_IN_VREF;
 	} else {
 		ret = kstrtou8(buf, 16, &data);


