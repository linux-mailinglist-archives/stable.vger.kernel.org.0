Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12123D8E3
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 11:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgHFJq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 05:46:29 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37768 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729132AbgHFJqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 05:46:14 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0769k6BU010684;
        Thu, 6 Aug 2020 04:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596707166;
        bh=Eg0nNwKYFPrdEyoew7NTOdZD/YSMF9Km0+p4yxjK4Sc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=nWb2EpEzNqn00iP58dYABkICNhXoRF+ZrDswbQPjFSSZLnaMXzkyhbeI25a5fQ311
         zU1NN1R3HNsbO2kArQGZ5+appz2ftmv0TpRXI+icPUvvT9rYUo8WUsMia8CP0SoMVv
         UPgKtbYwLDs60400AKids3gu/CG5NIgp8V0huhYU=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0769k6Xt103741;
        Thu, 6 Aug 2020 04:46:06 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 6 Aug
 2020 04:46:05 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 6 Aug 2020 04:46:05 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0769k4rr086043;
        Thu, 6 Aug 2020 04:46:04 -0500
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Greg KH <greg@kroah.com>
CC:     Adam Ford <aford173@gmail.com>, stable <stable@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>
References: <20200709121232.9827-1-aford173@gmail.com>
 <CAHCN7x+crwfE4pfufad_WEUhiJQXccSZHot+YNDZzZKvqhrmWA@mail.gmail.com>
 <86992356-b902-d7da-ffd7-e8b98f9252fd@ti.com>
 <20200805143328.GD2154236@kroah.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <df411c41-2b75-725e-9f49-4ca6124f3d4e@ti.com>
Date:   Thu, 6 Aug 2020 12:46:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805143328.GD2154236@kroah.com>
Content-Type: multipart/mixed;
        boundary="------------68CB34093B7850019439355E"
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--------------68CB34093B7850019439355E
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi Greg,

On 05/08/2020 17:33, Greg KH wrote:
> On Tue, Aug 04, 2020 at 04:19:54PM +0300, Tomi Valkeinen wrote:
>> On 04/08/2020 16:13, Adam Ford wrote:
>>>
>>>
>>> On Thu, Jul 9, 2020 at 7:12 AM Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>> wrote:
>>>
>>>     There appears to be a timing issue where using a divider of 32 breaks
>>>     the DSS for OMAP36xx despite the TRM stating 32 is a valid
>>>     number.  Through experimentation, it appears that 31 works.
>>>
>>>     This same fix was issued for kernels 4.5+.  However, between
>>>     kernels 4.4 and 4.5, the directory structure was changed when the
>>>     dss directory was moved inside the omapfb directory. That broke the
>>>     patch on kernels older than 4.5, because it didn't permit the patch
>>>     to apply cleanly for 4.4 and older.
>>>
>>>     A similar patch was applied to the 3.16 kernel already, but not to 4.4.
>>>     Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
>>>     on the 3.16 stable branch with notes from Ben about the path change.
>>>
>>>     Since this was applied for 3.16 already, this patch is for kernels
>>>     3.17 through 4.4 only.
>>>
>>>     Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
>>>
>>>     Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>> #3.17 - 4.4
>>>     CC: <tomi.valkeinen@ti.com <mailto:tomi.valkeinen@ti.com>>
>>>     Signed-off-by: Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>>
>>>
>>>
>>> Tomi,
>>>
>>> Can you comment on this?  The 4.4 is still waiting for this fix.  The other branches are fixed.
>>
>> Looks good to me.
>>
>> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> 
> I don't seem to have the original of this anymore, can someone please
> resend it?

I have attached the original.

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

--------------68CB34093B7850019439355E
Content-Type: application/mbox; name="fix-max-div.mbox"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fix-max-div.mbox"

RnJvbSAtIFRodSBBdWcgMDYgMTI6NDQ6MzUgMjAyMApSZWNlaXZlZDogZnJvbSBETEVFMTAz
LmVudC50aS5jb20gKDE1Ny4xNzAuMTcwLjMzKSBieSBETEVFMTA2LmVudC50aS5jb20NCiAo
MTU3LjE3MC4xNzAuMzYpIHdpdGggTWljcm9zb2Z0IFNNVFAgU2VydmVyICh2ZXJzaW9uPVRM
UzFfMiwNCiBjaXBoZXI9VExTX0VDREhFX1JTQV9XSVRIX0FFU18xMjhfQ0JDX1NIQTI1Nl9Q
MjU2KSBpZCAxNS4xLjE5NzkuMyB2aWEgTWFpbGJveA0KIFRyYW5zcG9ydDsgVGh1LCA5IEp1
bCAyMDIwIDA3OjEyOjQ3IC0wNTAwDQpSZWNlaXZlZDogZnJvbSBETEVFMTA1LmVudC50aS5j
b20gKDE1Ny4xNzAuMTcwLjM1KSBieSBETEVFMTAzLmVudC50aS5jb20NCiAoMTU3LjE3MC4x
NzAuMzMpIHdpdGggTWljcm9zb2Z0IFNNVFAgU2VydmVyICh2ZXJzaW9uPVRMUzFfMiwNCiBj
aXBoZXI9VExTX0VDREhFX1JTQV9XSVRIX0FFU18xMjhfQ0JDX1NIQTI1Nl9QMjU2KSBpZCAx
NS4xLjE5NzkuMzsgVGh1LCA5IEp1bA0KIDIwMjAgMDc6MTI6NDcgLTA1MDANClJlY2VpdmVk
OiBmcm9tIGxlbHYwMTQwLmV4dC50aS5jb20gKDEwLjQuMTIuNjcpIGJ5IERMRUUxMDUuZW50
LnRpLmNvbQ0KICgxNTcuMTcwLjE3MC4zNSkgd2l0aCBNaWNyb3NvZnQgU01UUCBTZXJ2ZXIg
aWQgMTUuMS4xOTc5LjMgdmlhIEZyb250ZW5kDQogVHJhbnNwb3J0OyBUaHUsIDkgSnVsIDIw
MjAgMDc6MTI6NDcgLTA1MDANClJlY2VpdmVkOiBmcm9tIG1haWw2LmJlbXRhMjMubWVzc2Fn
ZWxhYnMuY29tIChtYWlsNi5iZW10YTIzLm1lc3NhZ2VsYWJzLmNvbSBbNjcuMjE5LjI0Ni4x
NTNdKQ0KCWJ5IGxlbHYwMTQwLmV4dC50aS5jb20gKDguMTUuMi84LjE1LjIpIHdpdGggRVNN
VFBTIGlkIDA2OUNDbGpoMDU5NzQ1DQoJKHZlcnNpb249VExTdjEuMiBjaXBoZXI9REhFLVJT
QS1BRVMyNTYtR0NNLVNIQTM4NCBiaXRzPTI1NiB2ZXJpZnk9T0spDQoJZm9yIDx0b21pLnZh
bGtlaW5lbkB0aS5jb20+OyBUaHUsIDkgSnVsIDIwMjAgMDc6MTI6NDcgLTA1MDANClJlY2Vp
dmVkOiBmcm9tIFsxMDAuMTEyLjYuMjE2XSAodXNpbmcgVExTdjEuMiB3aXRoIGNpcGhlciBE
SEUtUlNBLUFFUzI1Ni1HQ00tU0hBMzg0ICgyNTYgYml0cykpDQoJYnkgc2VydmVyLTIuYmVt
dGEuYXotYy51cy1lYXN0LTEuYXdzLnN5bWNsZC5uZXQgaWQgOUIvNzYtNDM2MjItRkI5MDcw
RjU7IFRodSwgMDkgSnVsIDIwMjAgMTI6MTI6NDcgKzAwMDANCkF1dGhlbnRpY2F0aW9uLVJl
c3VsdHM6IG14Lm1lc3NhZ2VsYWJzLmNvbTsgc3BmPXBhc3MgDQogIChzZXJ2ZXItMzIudG93
ZXItNDAzLm1lc3NhZ2VsYWJzLmNvbTogZG9tYWluIG9mIGdtYWlsLmNvbSBkZXNpZ25hdGVz
IA0KICAyMDkuODUuMTY2LjE5NiBhcyBwZXJtaXR0ZWQgc2VuZGVyKSBzbXRwLm1haWxmcm9t
PWdtYWlsLmNvbTsgZGtpbT1wYXNzIA0KICAoZ29vZCBzaWduYXR1cmUpIGhlYWRlci5pPUBn
bWFpbC5jb20gaGVhZGVyLnM9MjAxNjEwMjU7IGRtYXJjPXBhc3MgDQogIChwPW5vbmUgc3A9
cXVhcmFudGluZSBhZGtpbT1yIGFzcGY9cikgaGVhZGVyLmZyb209Z21haWwuY29tDQpYLUJy
aWdodG1haWwtVHJhY2tlcjogSDRzSUFBQUFBQUFBQStOZ0ZyclBJc1dSV2xHU1dwU1htS1BF
eHNWeU1YVFpFZDE5bk96DQogIHhCbzJITkN6V3o3L0Y1c0RvY2Z6R2RxWUF4aWpXekx5ay9J
b0Uxb3pyKzA0ekZkemxyamd4K1NKTEErTXZ6aTVHTGc0aGdYNUcNCiAgaVphTm4xaEFIQmFC
WmxhSldWM1RtRUVjQ1lINXJCTEhUc3dFeW5BQ09Xa1NHelllWllPeGIwemR6d1JoMTBwczNQ
bWFHY1FXRQ0KICBsQ1V1SG4yRXp2RTJDVk1Fci8zN21VSFNiQUpxRWhNM25jVXFJR0RRMFJB
U3VMK1ZXdVFNTE5BcU1TejFxdGd2Y0lDOWhKTjkyDQogIGFCMlN3Q3FoSXZtaCt3Z3RpOEFt
WVN4NjZ1WUliWUpTOHg4OUozZG9pNG9NVEptVTlZSU9iSVN6UnZuYzA4Z1ZGd0ZwTFVMQ1MN
CiAgcEJZeE1xeGpOa29veTB6TktjaE16YzNRTkRReDBEUTJOZEUxMERTME45UktyZEpQMVNv
dDFVeE9MUzNTQjNQSml2ZUxLM09TYw0KICBGTDI4MUpKTmpNRHdUU2xnMmIrRDhjcnJEM3FI
R0NVNW1KUkVlU1haMk9PRitKTHlVeW96RW9zejRvdEtjMUtMRHpIS2NIQW9TDQogIGZBbWNB
RGxCSXRTMDFNcjBqSnpnTEVFazViZzRGRVM0YjBGa3VZdExrak1MYzVNaDBpZFlyVGtXTEp4
M2lKbWpvNWZpNERreVYNCiAgVkxGakVMc2VUbDU2VktpZk5tZ0RRSWdEUmtsT2JCallQRit5
VkdXU2xoWGtZR0JnWWhub0xVb3R6TUVsVDVWNHppSEl4S3dyeA0KICBYUWFid1pPYVZ3RzE5
QlhRUUU5QkJSem5ZUUE0cVNVUklTVFV3T1J4SXpULzlhRExYSjg1WkFxb3pqczFiYi9zcmVl
MTY5OEJEDQogIGRYc2xnMXd6N1BRaTk3Skl2WFcrOFc3bis2UHlCeFpkK1AzMzFVdmVrTVBM
TXowanRpdTA3aTM4YWFoM1VMUk9hS1gxaEQyYkENCiAgaWVxZjZveVh4M0xKcUJudFBIT2hs
a21EcjJPTVc5cm5tMTRlZnQxbDZRRjY0dEF0a2VheVd4cE5kTmZGNmxmN0tsaEx0S3NNMw0K
ICA2V3V1dythODl0SytuTGFocDlQY3VldGtjenBGWTdQbG4wSTN4SlM5YjVXYmQ1NTYvZ1gz
d3VZY3JFWC9mOWowVm1WeDM4WnU3DQogIEhieU5UZXBnclRVTnVzb1ZNdjBkUzRxY0N0Zm0y
dHY4OTdtKy9LeFVYbEpVdWRTcko1c212Z3VKcno1anplbTRJbmp0cG9YVXgNCiAgbVhGMndx
Y0p1cTRXKzg1Y09WVlVuc3ZEcFdleGZ0SmNKWmJpakVSRExlYWk0a1FBQStwMy8zSURBQUE9
DQpYLUVudi1TZW5kZXI6IGFmb3JkMTczQGdtYWlsLmNvbQ0KWC1Nc2ctUmVmOiBzZXJ2ZXIt
MzIudG93ZXItNDAzLm1lc3NhZ2VsYWJzLmNvbSExNTk0Mjk2NzY2ITkwMDI4MSExDQpYLU9y
aWdpbmF0aW5nLUlQOiBbMjA5Ljg1LjE2Ni4xOTZdDQpYLVNwYW1SZWFzb246IE5vLCBoaXRz
PTAuMCByZXF1aXJlZD03LjAgdGVzdHM9TUFJTFRPX1RPX1NQQU1fQUREUg0KWC1TdGFyU2Nh
bi1SZWNlaXZlZDoNClgtU3RhclNjYW4tVmVyc2lvbjogOS41MC4yOyBiYW5uZXJzPS0sLSwt
DQpYLVZpcnVzQ2hlY2tlZDogQ2hlY2tlZA0KUmVjZWl2ZWQ6IChxbWFpbCAyMTk3NyBpbnZv
a2VkIGZyb20gbmV0d29yayk7IDkgSnVsIDIwMjAgMTI6MTI6NDYgLTAwMDANClJlY2VpdmVk
OiBmcm9tIG1haWwtaWwxLWYxOTYuZ29vZ2xlLmNvbSAoSEVMTyBtYWlsLWlsMS1mMTk2Lmdv
b2dsZS5jb20pICgyMDkuODUuMTY2LjE5NikNCiAgYnkgc2VydmVyLTMyLnRvd2VyLTQwMy5t
ZXNzYWdlbGFicy5jb20gd2l0aCBFQ0RIRS1SU0EtQUVTMjU2LUdDTS1TSEEzODQgZW5jcnlw
dGVkIFNNVFA7IDkgSnVsIDIwMjAgMTI6MTI6NDYgLTAwMDANClJlY2VpdmVkOiBieSBtYWls
LWlsMS1mMTk2Lmdvb2dsZS5jb20gd2l0aCBTTVRQIGlkIHQxOHNvMTgyMDI5MWlsaC4yDQog
ICAgICAgIGZvciA8dG9taS52YWxrZWluZW5AdGkuY29tPjsgVGh1LCAwOSBKdWwgMjAyMCAw
NToxMjo0NiAtMDcwMCAoUERUKQ0KREtJTS1TaWduYXR1cmU6IHY9MTsgYT1yc2Etc2hhMjU2
OyBjPXJlbGF4ZWQvcmVsYXhlZDsNCiAgICAgICAgZD1nbWFpbC5jb207IHM9MjAxNjEwMjU7
DQogICAgICAgIGg9ZnJvbTp0bzpjYzpzdWJqZWN0OmRhdGU6bWVzc2FnZS1pZDptaW1lLXZl
cnNpb24NCiAgICAgICAgIDpjb250ZW50LXRyYW5zZmVyLWVuY29kaW5nOw0KICAgICAgICBi
aD1hQXN5QzZFZnl0RlN4U0lkcDNTTlE5a2JHdEkyNXdscmVaK0Q1OXdqSllZPTsNCiAgICAg
ICAgYj1yTkZpRUladnlFWmllY2Z6alZHN0d4N29CVC9LK3FmVkhOVkttMlR1eG9KNmNiT0d0
b3JlOCt0S1c4dzJzcW41KzMNCiAgICAgICAgIDNySmtkM25BSjMvQmVqWHVUWlBoajVXaW93
dGlCdVpkQzFmRUg0VE5KMXdzSjhKaWY1dmhScVlnUVVDc3YzbWI5UERzDQogICAgICAgICBP
YTNKWFd2cHIvSlVaUG9KWFAwbkF4V3NUbEdLNStZY2pxMzkwMnVsUU85aEdDZXh3aWNWK2NQ
MUpHU2hDOUM0U0ZvVQ0KICAgICAgICAgSlM5RmpoOC9IUEcyY25BekVmRE5hejR6VXgwK3Ny
Vkd2cStjTFNCczlFQ3gzV3ZkQVJFM2trblZpdWdrV3ZhRnlLeUINCiAgICAgICAgIENDN0M5
Z1hPRGFwMHdYdUljdXRaTyt0T1hLSVhFYmErU2NVNkJmaVl4V3IwZ2lKTWJuRDRnc2xlNkR3
RkdWb0trVlJpDQogICAgICAgICBBVjVRPT0NClgtR29vZ2xlLURLSU0tU2lnbmF0dXJlOiB2
PTE7IGE9cnNhLXNoYTI1NjsgYz1yZWxheGVkL3JlbGF4ZWQ7DQogICAgICAgIGQ9MWUxMDAu
bmV0OyBzPTIwMTYxMDI1Ow0KICAgICAgICBoPXgtZ20tbWVzc2FnZS1zdGF0ZTpmcm9tOnRv
OmNjOnN1YmplY3Q6ZGF0ZTptZXNzYWdlLWlkOm1pbWUtdmVyc2lvbg0KICAgICAgICAgOmNv
bnRlbnQtdHJhbnNmZXItZW5jb2Rpbmc7DQogICAgICAgIGJoPWFBc3lDNkVmeXRGU3hTSWRw
M1NOUTlrYkd0STI1d2xyZVorRDU5d2pKWVk9Ow0KICAgICAgICBiPUw5L25XWjROMWhlVVlR
Nno0TFlFZ0dHMkU1Qjk1R1R6N2U1VUVwWjlsZ2tGbHFiOXBJdzExcjNydEV4cXFqZVl4QQ0K
ICAgICAgICAgVnQ1RGZvaldVUzQyaEM1dUgzZmhBV1VDcG9RV013TmFzTk9kWmFrc0h6bXBv
aW1yR1lJN2NlWXR1Y0hLb2l4bXlUa20NCiAgICAgICAgIFk4VHJPVFFyZElKVjVidzNMcVg3
RXg3a2JWdExCdytsNVR6bmY2OXBtRjNJZW0vRmVrazlxR0VEVC96R2NaNGFJUDJhDQogICAg
ICAgICAwU3JYOEpEKzhSMUp2UWJpZEh1bnFQM2RXNVpKVVFTQjVBU2VvS2J6bDlrejhPTVYx
NTJOcUxJRzZzVjBieG9rcEQ4aw0KICAgICAgICAgSitWUXVSSk55dVFxWGxNM0EwZGdQb1I0
QzBFWFNRM0NrMGtSMWJVV3VKbEJxQ3g0S1hpcWJOVHQvbjhYdElndWxYYlkNCiAgICAgICAg
IGNrQ1E9PQ0KWC1HbS1NZXNzYWdlLVN0YXRlOiBBT0FNNTMyb1NVaDhJZWx6MGIrSHplelBC
QlBPTEF1ZG9HaGw0T2FGT3E0Qm9BWERaU2ZUWW9iQw0KCUNQYXVEWTh5Y0piK1pHYkxjMFNh
bmEwPQ0KWC1Hb29nbGUtU210cC1Tb3VyY2U6IEFCZGhQSndmOU5URVdmRTVPUWpBNm5TUmZJ
eXhmbUtweUZzMVg2ZlMxbUdjYklEcjk2TjVGQmNlZ2N0Q2NrY1M3cXNRRjhuVU8wdU53QT09
DQpYLVJlY2VpdmVkOiBieSAyMDAyOmE5MjpkYTRjOjogd2l0aCBTTVRQIGlkIHAxMm1yMTc4
MDk3ODdpbHEuMTQyLjE1OTQyOTY3NjU5NjE7DQogICAgICAgIFRodSwgMDkgSnVsIDIwMjAg
MDU6MTI6NDUgLTA3MDAgKFBEVCkNClJlY2VpdmVkOiBmcm9tIGFmb3JkLUlkZWFDZW50cmUt
QTczMC5sYW4gKGMtNzMtMzctMjE5LTIzNC5oc2QxLm1uLmNvbWNhc3QubmV0LiBbNzMuMzcu
MjE5LjIzNF0pDQogICAgICAgIGJ5IHNtdHAuZ21haWwuY29tIHdpdGggRVNNVFBTQSBpZCBp
MTg4c20yMDk2MTMxaW9hLjMzLjIwMjAuMDcuMDkuMDUuMTIuNDUNCiAgICAgICAgKHZlcnNp
b249VExTMV8zIGNpcGhlcj1UTFNfQUVTXzI1Nl9HQ01fU0hBMzg0IGJpdHM9MjU2LzI1Nik7
DQogICAgICAgIFRodSwgMDkgSnVsIDIwMjAgMDU6MTI6NDUgLTA3MDAgKFBEVCkNCkZyb206
IEFkYW0gRm9yZCA8YWZvcmQxNzNAZ21haWwuY29tPg0KVG86IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCkNjOiB0b21pLnZhbGtlaW5lbkB0aS5jb20sIGFmb3JkQGJlYWNvbmVtYmVkZGVk
LmNvbSwNCiAgICAgICAgQWRhbSBGb3JkIDxhZm9yZDE3M0BnbWFpbC5jb20+DQpTdWJqZWN0
OiBbUEFUQ0hdIG9tYXBmYjogZHNzOiBGaXggbWF4IGZjbGsgZGl2aWRlciBmb3Igb21hcDM2
eHgNCkRhdGU6IFRodSwgIDkgSnVsIDIwMjAgMDc6MTI6MzIgLTA1MDANCk1lc3NhZ2UtSWQ6
IDwyMDIwMDcwOTEyMTIzMi45ODI3LTEtYWZvcmQxNzNAZ21haWwuY29tPg0KWC1NYWlsZXI6
IGdpdC1zZW5kLWVtYWlsIDIuMjUuMQ0KQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJp
dA0KUmV0dXJuLVBhdGg6IGFmb3JkMTczQGdtYWlsLmNvbQ0KWC1NUy1FeGNoYW5nZS1Pcmdh
bml6YXRpb24tTmV0d29yay1NZXNzYWdlLUlkOiAxMWI0ZWE1Ny02ZWQ1LTRiNjktZGQxMC0w
OGQ4MjQwMTY0ZDANClgtTVMtRXhjaGFuZ2UtT3JnYW5pemF0aW9uLUF1dGhTb3VyY2U6IERM
RUUxMDUuZW50LnRpLmNvbQ0KWC1NUy1FeGNoYW5nZS1Pcmdhbml6YXRpb24tQXV0aEFzOiBJ
bnRlcm5hbA0KWC1NUy1FeGNoYW5nZS1Pcmdhbml6YXRpb24tQXV0aE1lY2hhbmlzbTogMTAN
CkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbg0KWC1NUy1FeGNoYW5nZS1Pcmdhbml6YXRpb24t
QVZTdGFtcC1NYWlsYm94OiBTWU1BTlRFQzsxOzA7aW5mbw0KWC1FWENMQUlNRVItTUQtQ09O
RklHOiBlMWU4YTJmZC1lNDBhLTRhYzYtYWM5Yi1mN2U5Y2M5ZWUxODANClgtTVMtRXhjaGFu
Z2UtVHJhbnNwb3J0LUVuZFRvRW5kTGF0ZW5jeTogMDA6MDA6MDAuMDM4NTQwNg0KWC1NUy1F
eGNoYW5nZS1Qcm9jZXNzZWQtQnktQmNjRm9sZGVyaW5nOiAxNS4wMS4xOTc5LjAwMg0KTUlN
RS1WZXJzaW9uOiAxLjANCg0KVGhlcmUgYXBwZWFycyB0byBiZSBhIHRpbWluZyBpc3N1ZSB3
aGVyZSB1c2luZyBhIGRpdmlkZXIgb2YgMzIgYnJlYWtzDQp0aGUgRFNTIGZvciBPTUFQMzZ4
eCBkZXNwaXRlIHRoZSBUUk0gc3RhdGluZyAzMiBpcyBhIHZhbGlkDQpudW1iZXIuICBUaHJv
dWdoIGV4cGVyaW1lbnRhdGlvbiwgaXQgYXBwZWFycyB0aGF0IDMxIHdvcmtzLg0KDQpUaGlz
IHNhbWUgZml4IHdhcyBpc3N1ZWQgZm9yIGtlcm5lbHMgNC41Ky4gIEhvd2V2ZXIsIGJldHdl
ZW4NCmtlcm5lbHMgNC40IGFuZCA0LjUsIHRoZSBkaXJlY3Rvcnkgc3RydWN0dXJlIHdhcyBj
aGFuZ2VkIHdoZW4gdGhlDQpkc3MgZGlyZWN0b3J5IHdhcyBtb3ZlZCBpbnNpZGUgdGhlIG9t
YXBmYiBkaXJlY3RvcnkuIFRoYXQgYnJva2UgdGhlDQpwYXRjaCBvbiBrZXJuZWxzIG9sZGVy
IHRoYW4gNC41LCBiZWNhdXNlIGl0IGRpZG4ndCBwZXJtaXQgdGhlIHBhdGNoDQp0byBhcHBs
eSBjbGVhbmx5IGZvciA0LjQgYW5kIG9sZGVyLg0KDQpBIHNpbWlsYXIgcGF0Y2ggd2FzIGFw
cGxpZWQgdG8gdGhlIDMuMTYga2VybmVsIGFscmVhZHksIGJ1dCBub3QgdG8gNC40Lg0KQ29t
bWl0IDRiOTExMTAxYTVjZCAoImRybS9vbWFwOiBmaXggbWF4IGZjbGsgZGl2aWRlciBmb3Ig
b21hcDM2eHgiKSBpcw0Kb24gdGhlIDMuMTYgc3RhYmxlIGJyYW5jaCB3aXRoIG5vdGVzIGZy
b20gQmVuIGFib3V0IHRoZSBwYXRoIGNoYW5nZS4NCg0KU2luY2UgdGhpcyB3YXMgYXBwbGll
ZCBmb3IgMy4xNiBhbHJlYWR5LCB0aGlzIHBhdGNoIGlzIGZvciBrZXJuZWxzDQozLjE3IHRo
cm91Z2ggNC40IG9ubHkuDQoNCkZpeGVzOiBmNzAxOGMyMTM1MDIgKCJ2aWRlbzogbW92ZSBm
YmRldiB0byBkcml2ZXJzL3ZpZGVvL2ZiZGV2IikNCg0KQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiAjMy4xNyAtIDQuNA0KQ0M6IDx0b21pLnZhbGtlaW5lbkB0aS5jb20+DQpTaWdu
ZWQtb2ZmLWJ5OiBBZGFtIEZvcmQgPGFmb3JkMTczQGdtYWlsLmNvbT4NCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdmlkZW8vZmJkZXYvb21hcDIvZHNzL2Rzcy5jIGIvZHJpdmVycy92aWRl
by9mYmRldi9vbWFwMi9kc3MvZHNzLmMNCmluZGV4IDkyMDBhODY2OGI0OS4uYTU3YzNhNWY0
YmY4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy92aWRlby9mYmRldi9vbWFwMi9kc3MvZHNzLmMN
CisrKyBiL2RyaXZlcnMvdmlkZW8vZmJkZXYvb21hcDIvZHNzL2Rzcy5jDQpAQCAtODQzLDcg
Kzg0Myw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNzX2ZlYXR1cmVzIG9tYXAzNHh4X2Rz
c19mZWF0cyA9IHsNCiB9Ow0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNzX2ZlYXR1cmVz
IG9tYXAzNjMwX2Rzc19mZWF0cyA9IHsNCi0JLmZja19kaXZfbWF4CQk9CTMyLA0KKwkuZmNr
X2Rpdl9tYXgJCT0JMzEsDQogCS5kc3NfZmNrX211bHRpcGxpZXIJPQkxLA0KIAkucGFyZW50
X2Nsa19uYW1lCT0JImRwbGw0X2NrIiwNCiAJLmRwaV9zZWxlY3Rfc291cmNlCT0JJmRzc19k
cGlfc2VsZWN0X3NvdXJjZV9vbWFwMl9vbWFwMywNCi0tIA0KMi4yNS4xDQoNCgo=
--------------68CB34093B7850019439355E--
