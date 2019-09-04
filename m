Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA3BA810F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 13:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfIDL1t convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Sep 2019 07:27:49 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva02.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfIDL1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 07:27:49 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2019 07:27:48 EDT
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 746F311A1B2;
        Wed,  4 Sep 2019 07:21:00 -0400 (EDT)
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6634011A073;
        Wed,  4 Sep 2019 07:21:00 -0400 (EDT)
Received: from LOUTCSGWY02.napa.ad.etn.com (loutcsgwy02.napa.ad.etn.com [151.110.126.85])
        by simtcimsva02.etn.com (Postfix) with ESMTPS;
        Wed,  4 Sep 2019 07:21:00 -0400 (EDT)
Received: from LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) by
 LOUTCSGWY02.napa.ad.etn.com (151.110.126.85) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 4 Sep 2019 07:20:26 -0400
Received: from SIMTCSMB12.napa.ad.etn.com ([::1]) by
 LOUTCSHUB01.napa.ad.etn.com ([::1]) with mapi id 14.03.0415.000; Wed, 4 Sep
 2019 07:20:25 -0400
From:   "Sonawane, Aashish P" <AashishPSonawane@eaton.com>
To:     "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "alexandre.belloni@free-electrons.com" 
        <alexandre.belloni@free-electrons.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Saitwal, Meghan" <MeghanSaitwal@Eaton.com>
Subject: [PATCH] rtc : Restricting year setting between 2000 to 2099 in
 rtc-s35390a driver
Thread-Topic: [PATCH] rtc : Restricting year setting between 2000 to 2099 in
 rtc-s35390a driver
Thread-Index: AdVjEakndAUJ/G1PSCGp98YjfVTSGw==
Date:   Wed, 4 Sep 2019 11:20:26 +0000
Message-ID: <29075B3123F59F41878316669231A55F0A9ED945@SIMTCSMB12.napa.ad.etn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [151.110.231.185]
x-tm-snts-smtp: DE2A5C5FFEA5AF39B9B7573E39A4D8EF037758E2BDEA8EB9A7E08C81A00380D02002:8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1817-8.5.0.1020-24888.006
X-TM-AS-Result: No--4.366-10.0-31-10
X-imss-scan-details: No--4.366-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1817-8.5.1020-24888.006
X-TMASE-Result: 10--4.366300-10.000000
X-TMASE-MatchedRID: ISENigBxYLt/ypuWOFMTEIH8AMdkLp7wou859sScIYo9O5uWt1X9I7kI
        QUnODKj7olMF7w4ybQB7QrEqZ4257HrSP9RtGZYoUeavKZUnS5Agdghl533NdWMunwKby/AXQBz
        oPKhLasiPqQJ9fQR1zq0vWYxKe6/Xfp+cLMwbvJmeAiCmPx4NwNivpTdmVCR2xEHRux+uk8ifEz
        J5hPndGctg3lGpBvECHLiJhZDfPBIHmiatbLFZ3Bcn1L3wcRQvPLQoQj+Xsh47eat77j5N5kZvo
        0MC1aBazliwi7EhOmceLG/J8mvSqxWsXlpwkvGbJb0gFsgtzp3jqmC1xdPTdfJ3vDpc0p9BVlxr
        1FJij9s=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


S-35390A RTC chip allows to set the lower two digit of the Western calendar year (00 to 99) and links together with the auto calendar from the year 2000 to the year 2099. If we try to set year earlier than 2000 then hardware clock get reset to "epoch". This patch check for year value between 2000 to 2099 otherwise returns "EINVAL" error. In conclusion this patch restricts system to set hardware clock to set year below and above the year 2000 and 2099 respectively.

Signed-off-by: Aashish P Sonawane mailto:AashishPSonawane@eaton.com
Suggested-by: Meghan Saitwal mailto:MeghanSaitwal@eaton.com
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------diff --git a/drivers/rtc/rtc-s35390a.c b/drivers/rtc/rtc-s35390a.c
index 84806ff763cf..aea52548571e 100644
--- a/drivers/rtc/rtc-s35390a.c
+++ b/drivers/rtc/rtc-s35390a.c
@@ -214,6 +214,9 @@ static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	int i, err;
 	char buf[7], status;
 
+	if (tm->tm_year < 100 || tm->tm_year > 199)
+		return EINVAL;
+
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
 		"mon=%d, year=%d, wday=%d\n", __func__, tm->tm_sec,
 		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
