Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E99D92CF
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405484AbfJPNpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:45:36 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17072 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbfJPNpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:45:36 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GDPqs3022516;
        Wed, 16 Oct 2019 15:45:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=mfO9AX3+TJvj3AYmpk6UXx63lG7kMkL0OHqCLaDLrEU=;
 b=wfTF8ROFfAn0GZvNOMeLOlZztVbiPwS6pK4py5C6wg2+Dav5TuLYW6v6ibHBgj+N9Hn1
 svL8knw+8IlVEEYinyJr0y2eyLqwzl8xjZMb3ILW6CDHHZ/DHklUub0F55d6+yHovnQa
 uIqOQcrkJgWsdAaW+8tOYS/H1fQstCKvWt2v0REAa3Chbuzvzhr07BL4MdPCJJOwOKP0
 5TfQzzbyrdIIelxe/9OB4ACq2+38tLwtAINgJnbIPt7uxqd+uNdM33HsnjkeycLnOQDz
 I/CnKoote7D3yc5q2Gj4dWnig88CF1mEDrLF8jbSxg6EvWXN23QqIZuYnHNOIQvzcPh0 mw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vk4a1efdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 15:45:20 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 577B210002A;
        Wed, 16 Oct 2019 15:45:20 +0200 (CEST)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4D7E121CA65;
        Wed, 16 Oct 2019 15:45:20 +0200 (CEST)
Received: from SAFEX1HUBCAS23.st.com (10.75.90.46) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 16 Oct
 2019 15:45:20 +0200
Received: from localhost (10.48.0.192) by webmail-ga.st.com (10.75.90.48) with
 Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 16 Oct 2019 15:45:19 +0200
From:   Fabrice Gasnier <fabrice.gasnier@st.com>
To:     <stable@vger.kernel.org>
CC:     <sashal@kernel.org>, <Jonathan.Cameron@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 0/2] backport iio: stm32-adc: fix a race with dma and irq
Date:   Wed, 16 Oct 2019 15:44:53 +0200
Message-ID: <1571233495-6065-1-git-send-email-fabrice.gasnier@st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.48.0.192]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_06:2019-10-16,2019-10-16 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of "iio: stm32-adc: fix a race with dma and irq" series
on top of v4.14.148 at the time of writing. The original series doesn't
apply cleanly on v4.14.x: the precursor patch needed a slight update.

Original series can be found in [1].
[1] https://www.lkml.org/lkml/2019/9/17/394

Original cover-letter:
This series fixes a race condition observed when using several ADCs with DMA
and irq.
There's a precusor patch to the fix. It keeps registers definitions as a whole
block, to ease readability and allow simple (readl) access path to EOC bits in
stm32-adc-core driver.

Fabrice Gasnier (2):
  iio: adc: stm32-adc: move registers definitions
  iio: adc: stm32-adc: fix a race when using several adcs with dma and
    irq

 drivers/iio/adc/stm32-adc-core.c |  70 +++++++++++---------
 drivers/iio/adc/stm32-adc-core.h | 135 +++++++++++++++++++++++++++++++++++++++
 drivers/iio/adc/stm32-adc.c      | 107 -------------------------------
 3 files changed, 175 insertions(+), 137 deletions(-)

-- 
2.7.4

