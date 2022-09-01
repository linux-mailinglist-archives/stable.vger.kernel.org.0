Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161035A8A9D
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 03:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiIAB1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 21:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIAB1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 21:27:05 -0400
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 Aug 2022 18:27:03 PDT
Received: from m13124.mail.163.com (m13124.mail.163.com [220.181.13.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5807DF8ED0;
        Wed, 31 Aug 2022 18:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=wklvF
        McU6a1O/ieCwawStIn4ZJ23CQ5U9F/SjOyVnuQ=; b=fndzgPbnVx87DSou+W9fF
        KtD5VtGjL6M3UXMjr2mTfqjyvHuN9l8nmGydOl2rizSr613GyD9C+sxq3qJ1G5b3
        5aOIT1dVmYBPKvz5cQP/nIoPFWaBp061lhQpT8ZYvW6GM7vfkua2lQ6umhzEWZ7m
        wf7kKrZhT4eRK0EiimIGss=
Received: from 15815827059$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr124 (Coremail) ; Thu, 1 Sep 2022 09:11:13 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date:   Thu, 1 Sep 2022 09:11:13 +0800 (CST)
From:   huhai <15815827059@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, huhai <huhai@kylinos.cn>,
        stable@vger.kernel.org, "Jackie Liu" <liuyun01@kylinos.cn>
Subject: Re:[PATCH] scsi: mpt3sas: Fix NULL pointer crash due to missing
 check device hostdata
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <20220825092645.326953-1-15815827059@163.com>
References: <20220825092645.326953-1-15815827059@163.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <49b0768d.96d.182f69a26f6.Coremail.15815827059@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: fMGowAB3OWGyBhBjz2NIAA--.53649W
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/1tbiHQ9phWI66iLJ0wACs2
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJpZW5kbHkgcGluZy4KCgpBdCAyMDIyLTA4LTI1IDE3OjI2OjQ1LCAiaHVoYWkiIDwxNTgxNTgy
NzA1OUAxNjMuY29tPiB3cm90ZToKPkZyb206IGh1aGFpIDxodWhhaUBreWxpbm9zLmNuPgo+Cj5J
ZiBfc2NzaWhfaW9fZG9uZSgpIGlzIGNhbGxlZCB3aXRoIHNjbWQtPmRldmljZS0+aG9zdGRhdGE9
TlVMTCwgaXQgY2FuIGxlYWQKPnRvIHRoZSBmb2xsb3dpbmcgcGFuaWM6Cj4KPiAgQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAw
MDAwMDAxOAo+ICBQR0QgNDU0N2E0MDY3IFA0RCA0NTQ3YTQwNjcgUFVEIDAKPiAgT29wczogMDAw
MiBbIzFdIFNNUCBOT1BUSQo+ICBDUFU6IDYyIFBJRDogMCBDb21tOiBzd2FwcGVyLzYyIEtkdW1w
OiBsb2FkZWQgTm90IHRhaW50ZWQgNC4xOS45MC0yNC40LnYyMTAxLmt5MTAueDg2XzY0ICMxCj4g
IEhhcmR3YXJlIG5hbWU6IFN0b3JhZ2UgU2VydmVyLzY1TjMyLVVTLCBCSU9TIFNRTDEwNDEyMTcg
MDUvMzAvMjAyMgo+ICBSSVA6IDAwMTA6X3Njc2loX3NldF9zYXRsX3BlbmRpbmcrMHgyZC8weDUw
IFttcHQzc2FzXQo+ICBDb2RlOiAwMCAwMCA0OCA4YiA4NyA2MCAwMSAwMCAwMCAwZiBiNiAxMCA4
MCBmYSBhMSA3NCAwOSAzMSBjMCA4MCBmYSA4NSA3NCAwMiBmMyBjMyA0OCA4YiA0NyAzOCA0MCA4
NCBmNiA0OCA4YiA4MCA5OCAwMCAwMCAwMCA3NSAwOCA8ZjA+IDgwIDYwIDE4IGZlIDMxIGMwIGMz
IGYwIDQ4IDBmIGJhIDY4IDE4IDAwIDBmIDkyIGMwIDBmIGI2IGMwIGMzCj4gIFJTUDogMDAxODpm
ZmZmOGVjMjJmYzAzZTAwIEVGTEFHUzogMDAwMTAwNDYKPiAgUkFYOiAwMDAwMDAwMDAwMDAwMDAw
IFJCWDogZmZmZjhlYmExYjA3MjUxOCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDEKPiAgUkRYOiAwMDAw
MDAwMDAwMDAwMDg1IFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6IGZmZmY4ZWJhMWIwNzI1MTgK
PiAgUkJQOiAwMDAwMDAwMDAwMDAwZGJkIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAw
MDAwMDAwMjk3MDAKPiAgUjEwOiBmZmZmOGVjMjJmYzAzZjgwIFIxMTogMDAwMDAwMDAwMDAwMDAw
MCBSMTI6IGZmZmY4ZWJlMmQzNjA5ZTgKPiAgUjEzOiBmZmZmOGViZTJhNzJiNjAwIFIxNDogZmZm
ZjhlY2E0NzI3MDdlMCBSMTU6IDAwMDAwMDAwMDAwMDAwMjAKPiAgRlM6ICAwMDAwMDAwMDAwMDAw
MDAwKDAwMDApIEdTOmZmZmY4ZWMyMmZjMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MAo+ICBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCj4g
IENSMjogMDAwMDAwMDAwMDAwMDAxOCBDUjM6IDAwMDAwMDA0NmU1ZjYwMDAgQ1I0OiAwMDAwMDAw
MDAwMzQwNmUwCj4gIENhbGwgVHJhY2U6Cj4gICA8SVJRPgo+ICAgX3Njc2loX2lvX2RvbmUrMHg0
YS8weDlmMCBbbXB0M3Nhc10KPiAgIF9iYXNlX2ludGVycnVwdCsweDIzZi8weGUxMCBbbXB0M3Nh
c10KPiAgIF9faGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg0MC8weDE5MAo+ICAgaGFuZGxlX2ly
cV9ldmVudF9wZXJjcHUrMHgzMC8weDcwCj4gICBoYW5kbGVfaXJxX2V2ZW50KzB4MzYvMHg2MAo+
ICAgaGFuZGxlX2VkZ2VfaXJxKzB4N2UvMHgxOTAKPiAgIGhhbmRsZV9pcnErMHhhOC8weDExMAo+
ICAgZG9fSVJRKzB4NDkvMHhlMAo+Cj5GaXggaXQgYnkgbW92ZSBzY21kLT5kZXZpY2UtPmhvc3Rk
YXRhIGNoZWNrIGJlZm9yZSBfc2NzaWhfc2V0X3NhdGxfcGVuZGluZwo+Y2FsbGVkLgo+Cj5PdGhl
ciBjaGFuZ2VzOgo+LSBJdCBsb29rcyBjbGVhciB0byBtb3ZlIGdldCBtcGlfcmVwbHkgdG8gbmVh
ciBpdHMgY2hlY2suCj4KPkZpeGVzOiBmZmI1ODQ1NjU4OTQgKCJzY3NpOiBtcHQzc2FzOiBmaXgg
aGFuZyBvbiBhdGEgcGFzc3Rocm91Z2ggY29tbWFuZHMiKQo+Q2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiAjIHY0LjkrCj5Dby1kZXZlbG9wZWQtYnk6IEphY2tpZSBMaXUgPGxpdXl1bjAxQGt5
bGlub3MuY24+Cj5TaWduZWQtb2ZmLWJ5OiBKYWNraWUgTGl1IDxsaXV5dW4wMUBreWxpbm9zLmNu
Pgo+U2lnbmVkLW9mZi1ieTogaHVoYWkgPGh1aGFpQGt5bGlub3MuY24+Cj4tLS0KPiBkcml2ZXJz
L3Njc2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2loLmMgfCAxNSArKysrKysrLS0tLS0tLS0KPiAxIGZp
bGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQo+Cj5kaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jIGIvZHJpdmVycy9zY3NpL21w
dDNzYXMvbXB0M3Nhc19zY3NpaC5jCj5pbmRleCBkZWYzN2E3ZTU5ODAuLjg1ZjU3NDlhMDQyMSAx
MDA2NDQKPi0tLSBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYwo+KysrIGIv
ZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jCj5AQCAtNTcwNCwyNyArNTcwNCwy
NiBAQCBfc2NzaWhfaW9fZG9uZShzdHJ1Y3QgTVBUM1NBU19BREFQVEVSICppb2MsIHUxNiBzbWlk
LCB1OCBtc2l4X2luZGV4LCB1MzIgcmVwbHkpCj4gCXN0cnVjdCBNUFQzU0FTX0RFVklDRSAqc2Fz
X2RldmljZV9wcml2X2RhdGE7Cj4gCXUzMiByZXNwb25zZV9jb2RlID0gMDsKPiAKPi0JbXBpX3Jl
cGx5ID0gbXB0M3Nhc19iYXNlX2dldF9yZXBseV92aXJ0X2FkZHIoaW9jLCByZXBseSk7Cj4tCj4g
CXNjbWQgPSBtcHQzc2FzX3Njc2loX3Njc2lfbG9va3VwX2dldChpb2MsIHNtaWQpOwo+IAlpZiAo
c2NtZCA9PSBOVUxMKQo+IAkJcmV0dXJuIDE7Cj4gCj4rCXNhc19kZXZpY2VfcHJpdl9kYXRhID0g
c2NtZC0+ZGV2aWNlLT5ob3N0ZGF0YTsKPisJaWYgKCFzYXNfZGV2aWNlX3ByaXZfZGF0YSB8fCAh
c2FzX2RldmljZV9wcml2X2RhdGEtPnNhc190YXJnZXQgfHwKPisJICAgICBzYXNfZGV2aWNlX3By
aXZfZGF0YS0+c2FzX3RhcmdldC0+ZGVsZXRlZCkgewo+KwkJc2NtZC0+cmVzdWx0ID0gRElEX05P
X0NPTk5FQ1QgPDwgMTY7Cj4rCQlnb3RvIG91dDsKPisJfQo+IAlfc2NzaWhfc2V0X3NhdGxfcGVu
ZGluZyhzY21kLCBmYWxzZSk7Cj4gCj4gCW1waV9yZXF1ZXN0ID0gbXB0M3Nhc19iYXNlX2dldF9t
c2dfZnJhbWUoaW9jLCBzbWlkKTsKPiAKPisJbXBpX3JlcGx5ID0gbXB0M3Nhc19iYXNlX2dldF9y
ZXBseV92aXJ0X2FkZHIoaW9jLCByZXBseSk7Cj4gCWlmIChtcGlfcmVwbHkgPT0gTlVMTCkgewo+
IAkJc2NtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2Owo+IAkJZ290byBvdXQ7Cj4gCX0KPiAKPi0J
c2FzX2RldmljZV9wcml2X2RhdGEgPSBzY21kLT5kZXZpY2UtPmhvc3RkYXRhOwo+LQlpZiAoIXNh
c19kZXZpY2VfcHJpdl9kYXRhIHx8ICFzYXNfZGV2aWNlX3ByaXZfZGF0YS0+c2FzX3RhcmdldCB8
fAo+LQkgICAgIHNhc19kZXZpY2VfcHJpdl9kYXRhLT5zYXNfdGFyZ2V0LT5kZWxldGVkKSB7Cj4t
CQlzY21kLT5yZXN1bHQgPSBESURfTk9fQ09OTkVDVCA8PCAxNjsKPi0JCWdvdG8gb3V0Owo+LQl9
Cj4gCWlvY19zdGF0dXMgPSBsZTE2X3RvX2NwdShtcGlfcmVwbHktPklPQ1N0YXR1cyk7Cj4gCj4g
CS8qCj4tLSAKPjIuMjcuMAo+Cj4KPk5vIHZpcnVzIGZvdW5kCj4JCUNoZWNrZWQgYnkgSGlsbHN0
b25lIE5ldHdvcmsgQW50aVZpcnVzCg==
