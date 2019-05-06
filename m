Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43AD14DB6
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfEFOp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbfEFOp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:45:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F1521479;
        Mon,  6 May 2019 14:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153955;
        bh=eyFQyilBY65uHC4KqCfyG7XQzSgs6BspptZVvJr2wYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y20+d2C/eyftRu+Y94UJUc+cbgky843rL/9HXG6O/QDwCbGp8VUd1CBH7XtGmD890
         wcVmhM3eq3DreodLyIlRGPtACm9TEDwxDsq33uloIITz3ZY7WFzmgqKNRK9GVaOLX0
         psoXNaxgM4fRjTny/IJK1QlXi1oqvZoza7tsI5Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Fertic <jeremyfertic@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 60/75] staging: iio: adt7316: allow adt751x to use internal vref for all dacs
Date:   Mon,  6 May 2019 16:33:08 +0200
Message-Id: <20190506143058.724483627@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
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
@@ -1086,7 +1086,7 @@ static ssize_t adt7316_store_DAC_interna
 		ldac_config = chip->ldac_config & (~ADT7516_DAC_IN_VREF_MASK);
 		if (data & 0x1)
 			ldac_config |= ADT7516_DAC_AB_IN_VREF;
-		else if (data & 0x2)
+		if (data & 0x2)
 			ldac_config |= ADT7516_DAC_CD_IN_VREF;
 	} else {
 		ret = kstrtou8(buf, 16, &data);


