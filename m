Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9C7365AB8
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhDTODl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 10:03:41 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44052 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232635AbhDTODk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 10:03:40 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KE2YaC007893;
        Tue, 20 Apr 2021 16:03:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : subject : to
 : cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=selector1;
 bh=DW5eupnkxeqQpga42kCG+Dbpq7cLHuZLAsTSyVhlscs=;
 b=K28LBLmKKa6XMNR9fsbOvpdhBWVsf5One+n4X09EuYjoqt6ICP2c7hBtzIRURriOOY40
 wuS0yFqw8VLrNh3nfRrJymJSd3E/CIC9JJhtxMv/AImHZT9U/6FkZUh1bL0zXh52z9iZ
 kK1zOb3Am9mt/qcmyCNYpcGrjLtQURMXosrdjKBnGphvDXDgJQ+aZKOR1bF4s7X0dyzD
 QHxxGY+w+I83hvBd5YlprZXaEwfuT6afPzQOP/mV+1/BgQigVXigYgvCixz9TPseHuXF
 KSI6G+h4XlWgRq+sRbyzgqxphYRrf23eSXPeTfOnUlBZr+n9nXvvjgI5aqsu4bM1fF64 Vg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 381jn8v9ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 16:03:01 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id F14D110002A;
        Tue, 20 Apr 2021 16:02:59 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DDE3021BD2E;
        Tue, 20 Apr 2021 16:02:59 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.48) by SFHDAG2NODE3.st.com
 (10.75.127.6) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 16:02:59 +0200
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
Subject: [v5.4 stable] arm: stm32: Regression observed on "no-map" reserved
 memory region
To:     Quentin Perret <qperret@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     <stable@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>
Message-ID: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
Date:   Tue, 20 Apr 2021 16:02:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG3NODE2.st.com (10.75.127.8) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_06:2021-04-20,2021-04-20 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map" 
reserved-memory regions are no more "reserved" and make part of the 
kernel System RAM. This causes allocation failure for devices which try 
to take a reserved-memory region.

It has been introduced by the following path:

"fdt: Properly handle "no-map" field in the memory region
[ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
which replace memblock_remove by memblock_mark_nomap in no-map case.

Reverting this patch it's fine.

I add part of my DT (something is maybe wrong inside):

memory@c0000000 {
	reg = <0xc0000000 0x20000000>;
};

reserved-memory {
	#address-cells = <1>;
	#size-cells = <1>;
	ranges;

	gpu_reserved: gpu@d4000000 {
		reg = <0xd4000000 0x4000000>;
		no-map;
	};
};

Sorry if this issue has already been raised and discussed.

Thanks
alex
