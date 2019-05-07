Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7DB167FC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfEGQf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:35:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726476AbfEGQf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:35:57 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x47GWPEl074445
        for <stable@vger.kernel.org>; Tue, 7 May 2019 12:35:55 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sbc6scft7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 07 May 2019 12:35:55 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ldufour@linux.vnet.ibm.com>;
        Tue, 7 May 2019 17:35:52 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 May 2019 17:35:48 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x47GZlkX49414158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 May 2019 16:35:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 811DFA405C;
        Tue,  7 May 2019 16:35:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7771A4054;
        Tue,  7 May 2019 16:35:46 +0000 (GMT)
Received: from nimbus.lab.toulouse-stg.fr.ibm.com (unknown [9.101.4.33])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 May 2019 16:35:46 +0000 (GMT)
Subject: Re: [PATCH] x86/mpx: fix recursive munmap() corruption
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, rguenther@suse.de,
        mhocko@suse.com, vbabka@suse.cz, luto@amacapital.net,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20190401141549.3F4721FE@viggo.jf.intel.com>
 <alpine.DEB.2.21.1904191248090.3174@nanos.tec.linutronix.de>
 <87d0lht1c0.fsf@concordia.ellerman.id.au>
 <6718ede2-1fcb-1a8f-a116-250eef6416c7@linux.vnet.ibm.com>
 <4f43d4d4-832d-37bc-be7f-da0da735bbec@intel.com>
 <4e1bbb14-e14f-8643-2072-17b4cdef5326@linux.vnet.ibm.com>
 <87k1faa2i0.fsf@concordia.ellerman.id.au>
From:   Laurent Dufour <ldufour@linux.vnet.ibm.com>
Date:   Tue, 7 May 2019 18:35:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87k1faa2i0.fsf@concordia.ellerman.id.au>
Content-Type: multipart/mixed;
 boundary="------------DB04FC2ECDCA90F932F2D5E3"
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19050716-0016-0000-0000-000002794308
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050716-0017-0000-0000-000032D5EE1D
Message-Id: <9c2b2826-4083-fc9c-5a4d-c101858dd560@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-07_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905070107
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------DB04FC2ECDCA90F932F2D5E3
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 01/05/2019 à 12:32, Michael Ellerman a écrit :
> Laurent Dufour <ldufour@linux.vnet.ibm.com> writes:
>> Le 23/04/2019 à 18:04, Dave Hansen a écrit :
>>> On 4/23/19 4:16 AM, Laurent Dufour wrote:
> ...
>>>> There are 2 assumptions here:
>>>>    1. 'start' and 'end' are page aligned (this is guaranteed by __do_munmap().
>>>>    2. the VDSO is 1 page (this is guaranteed by the union vdso_data_store on powerpc)
>>>
>>> Are you sure about #2?  The 'vdso64_pages' variable seems rather
>>> unnecessary if the VDSO is only 1 page. ;)
>>
>> Hum, not so sure now ;)
>> I got confused, only the header is one page.
>> The test is working as a best effort, and don't cover the case where
>> only few pages inside the VDSO are unmmapped (start >
>> mm->context.vdso_base). This is not what CRIU is doing and so this was
>> enough for CRIU support.
>>
>> Michael, do you think there is a need to manage all the possibility
>> here, since the only user is CRIU and unmapping the VDSO is not a so
>> good idea for other processes ?
> 
> Couldn't we implement the semantic that if any part of the VDSO is
> unmapped then vdso_base is set to zero? That should be fairly easy, eg:
> 
> 	if (start < vdso_end && end >= mm->context.vdso_base)
> 		mm->context.vdso_base = 0;
> 
> 
> We might need to add vdso_end to the mm->context, but that should be OK.
> 
> That seems like it would work for CRIU and make sense in general?

Sorry for the late answer, yes this would make more sense.

Here is a patch doing that.

Cheers,
Laurent



--------------DB04FC2ECDCA90F932F2D5E3
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-powerpc-vdso-handle-generic-unmap-of-the-VDSO.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-powerpc-vdso-handle-generic-unmap-of-the-VDSO.patch"

RnJvbSA1YjY0YTg2YzJhODA0MmM3Nzg1YzNkM2Y1ZTU4ZTk1NGEyYzhjODQzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMYXVyZW50IER1Zm91ciA8bGR1Zm91ckBsaW51eC5p
Ym0uY29tPgpEYXRlOiBUdWUsIDcgTWF5IDIwMTkgMTY6Mjk6NDYgKzAyMDAKU3ViamVjdDog
W1BBVENIXSBwb3dlcnBjL3Zkc286IGhhbmRsZSBnZW5lcmljIHVubWFwIG9mIHRoZSBWRFNP
CgpNYWtlIHRoZSB1bm1hcCBvZiB0aGUgVkRTTyBtb3JlIGdlbmVyaWMgYnkgY2hlY2tpbmcg
Zm9yIHRoZSBzdGFydCBhbmQgZW5kCm9mIHRoZSBWRFNPLgoKVGhpcyBpbXBsaWVzIHRvIGFk
ZCB0aGUgdmRzb19lbmQgYWRkcmVzcyBpbiB0aGUgbW1fY29udGV4dF90IHN0cnVjdHVyZS4K
ClNpZ25lZC1vZmYtYnk6IExhdXJlbnQgRHVmb3VyIDxsZHVmb3VyQGxpbnV4LmlibS5jb20+
CkNjOiBNaWNoYWVsIEVsbGVybWFuIDxtcGVAZWxsZXJtYW4uaWQuYXU+CkNjOiBCZW5qYW1p
biBIZXJyZW5zY2htaWR0IDxiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmc+CkNjOiBQYXVsIE1h
Y2tlcnJhcyA8cGF1bHVzQHNhbWJhLm9yZz4KLS0tCiBhcmNoL3Bvd2VycGMvaW5jbHVkZS9h
c20vYm9vazNzLzMyL21tdS1oYXNoLmggfCAgMyArKy0KIGFyY2gvcG93ZXJwYy9pbmNsdWRl
L2FzbS9ib29rM3MvNjQvbW11LmggICAgICB8ICAyICstCiBhcmNoL3Bvd2VycGMvaW5jbHVk
ZS9hc20vbW0tYXJjaC1ob29rcy5oICAgICAgfCAgNSArKysrLQogYXJjaC9wb3dlcnBjL2lu
Y2x1ZGUvYXNtL21tdV9jb250ZXh0LmggICAgICAgIHwgMjEgKysrKysrKysrKysrKysrKyst
LQogYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL25vaGFzaC8zMi9tbXUtNDB4LmggIHwgIDIg
Ky0KIGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ub2hhc2gvMzIvbW11LTQ0eC5oICB8ICAy
ICstCiBhcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL21tdS04eHguaCAgfCAg
MiArLQogYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL25vaGFzaC9tbXUtYm9vazNlLmggIHwg
IDIgKy0KIGFyY2gvcG93ZXJwYy9rZXJuZWwvdmRzby5jICAgICAgICAgICAgICAgICAgICB8
ICAyICsrCiA5IGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Jvb2szcy8zMi9t
bXUtaGFzaC5oIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Jvb2szcy8zMi9tbXUtaGFz
aC5oCmluZGV4IDJlMjc3Y2EwMTcwZi4uNDUyMTUyYjgwOWZjIDEwMDY0NAotLS0gYS9hcmNo
L3Bvd2VycGMvaW5jbHVkZS9hc20vYm9vazNzLzMyL21tdS1oYXNoLmgKKysrIGIvYXJjaC9w
b3dlcnBjL2luY2x1ZGUvYXNtL2Jvb2szcy8zMi9tbXUtaGFzaC5oCkBAIC0yOSw2ICsyOSw3
IEBACiAjZGVmaW5lIEJQUF9SWAkweDAxCQkvKiBSZWFkIG9ubHkgKi8KICNkZWZpbmUgQlBQ
X1JXCTB4MDIJCS8qIFJlYWQvd3JpdGUgKi8KIAorCiAjaWZuZGVmIF9fQVNTRU1CTFlfXwog
LyogQ29udG9ydCBhIHBoeXNfYWRkcl90IGludG8gdGhlIHJpZ2h0IGZvcm1hdC9iaXRzIGZv
ciBhIEJBVCAqLwogI2lmZGVmIENPTkZJR19QSFlTXzY0QklUCkBAIC05MCw3ICs5MSw3IEBA
IHN0cnVjdCBoYXNoX3B0ZSB7CiAKIHR5cGVkZWYgc3RydWN0IHsKIAl1bnNpZ25lZCBsb25n
IGlkOwotCXVuc2lnbmVkIGxvbmcgdmRzb19iYXNlOworCXVuc2lnbmVkIGxvbmcgdmRzb19i
YXNlLCB2ZHNvX2VuZDsKIH0gbW1fY29udGV4dF90OwogCiB2b2lkIHVwZGF0ZV9iYXRzKHZv
aWQpOwpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Jvb2szcy82NC9t
bXUuaCBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ib29rM3MvNjQvbW11LmgKaW5kZXgg
NzRkMjQyMDFmYzRmLi43YTVhOTFhMDY5NmYgMTAwNjQ0Ci0tLSBhL2FyY2gvcG93ZXJwYy9p
bmNsdWRlL2FzbS9ib29rM3MvNjQvbW11LmgKKysrIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUv
YXNtL2Jvb2szcy82NC9tbXUuaApAQCAtMTIwLDcgKzEyMCw3IEBAIHR5cGVkZWYgc3RydWN0
IHsKIAlzdHJ1Y3QgbnB1X2NvbnRleHQgKm5wdV9jb250ZXh0OwogCXN0cnVjdCBoYXNoX21t
X2NvbnRleHQgKmhhc2hfY29udGV4dDsKIAotCXVuc2lnbmVkIGxvbmcgdmRzb19iYXNlOwor
CXVuc2lnbmVkIGxvbmcgdmRzb19iYXNlLCB2ZHNvX2VuZDsKIAkvKgogCSAqIHBhZ2V0YWJs
ZSBmcmFnbWVudCBzdXBwb3J0CiAJICovCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5j
bHVkZS9hc20vbW0tYXJjaC1ob29rcy5oIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL21t
LWFyY2gtaG9va3MuaAppbmRleCBmMmEyZGE4OTU4OTcuLjFlMmQ1MjdkM2QxZiAxMDA2NDQK
LS0tIGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL21tLWFyY2gtaG9va3MuaAorKysgYi9h
cmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbW0tYXJjaC1ob29rcy5oCkBAIC0xNiwxMiArMTYs
MTUgQEAgc3RhdGljIGlubGluZSB2b2lkIGFyY2hfcmVtYXAoc3RydWN0IG1tX3N0cnVjdCAq
bW0sCiAJCQkgICAgICB1bnNpZ25lZCBsb25nIG9sZF9zdGFydCwgdW5zaWduZWQgbG9uZyBv
bGRfZW5kLAogCQkJICAgICAgdW5zaWduZWQgbG9uZyBuZXdfc3RhcnQsIHVuc2lnbmVkIGxv
bmcgbmV3X2VuZCkKIHsKKwl1bnNpZ25lZCBsb25nIGxlbmd0aCA9IG1tLT5jb250ZXh0LnZk
c29fZW5kIC0gbW0tPmNvbnRleHQudmRzb19iYXNlOwogCS8qCiAJICogbXJlbWFwKCkgZG9l
c24ndCBhbGxvdyBtb3ZpbmcgbXVsdGlwbGUgdm1hcyBzbyB3ZSBjYW4gbGltaXQgdGhlCiAJ
ICogY2hlY2sgdG8gb2xkX3N0YXJ0ID09IHZkc29fYmFzZS4KIAkgKi8KLQlpZiAob2xkX3N0
YXJ0ID09IG1tLT5jb250ZXh0LnZkc29fYmFzZSkKKwlpZiAob2xkX3N0YXJ0ID09IG1tLT5j
b250ZXh0LnZkc29fYmFzZSkgeworCQltbS0+Y29udGV4dC52ZHNvX2VuZCA9IG5ld19zdGFy
dCArIGxlbmd0aDsKIAkJbW0tPmNvbnRleHQudmRzb19iYXNlID0gbmV3X3N0YXJ0OworCX0K
IH0KICNkZWZpbmUgYXJjaF9yZW1hcCBhcmNoX3JlbWFwCiAKZGlmZiAtLWdpdCBhL2FyY2gv
cG93ZXJwYy9pbmNsdWRlL2FzbS9tbXVfY29udGV4dC5oIGIvYXJjaC9wb3dlcnBjL2luY2x1
ZGUvYXNtL21tdV9jb250ZXh0LmgKaW5kZXggNjExMjA0ZTU4OGI5Li5jMjRmNWVkMGFlZmYg
MTAwNjQ0Ci0tLSBhL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9tbXVfY29udGV4dC5oCisr
KyBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9tbXVfY29udGV4dC5oCkBAIC0yMzUsOCAr
MjM1LDI1IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBhcmNoX3VubWFwKHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tLAogCQkJICAgICAgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsCiAJCQkgICAg
ICB1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCkKIHsKLQlpZiAoc3Rh
cnQgPD0gbW0tPmNvbnRleHQudmRzb19iYXNlICYmIG1tLT5jb250ZXh0LnZkc29fYmFzZSA8
IGVuZCkKLQkJbW0tPmNvbnRleHQudmRzb19iYXNlID0gMDsKKwl1bnNpZ25lZCBsb25nIHZk
c29fYmFzZSwgdmRzb19lbmQ7CisKKwl2ZHNvX2Jhc2UgPSBtbS0+Y29udGV4dC52ZHNvX2Jh
c2U7CisJdmRzb19lbmQgPSBtbS0+Y29udGV4dC52ZHNvX2VuZDsKKworCS8qCisJICogUGFy
dGlhbCB1bm1hcHBpbmcgb2YgcGFnZXMgaW5zaWRlIHRoZSBWRFNPLCBpcyBjb25zaWRlciBl
cXVpdmFsZW50CisJICogdG8gdW5tYXBwaW5nIHRoZSBWRFNPLgorCSAqCisJICogY2FzZSAx
ICAgPiAgfCAgICAgVkRTTyAgICB8ICA8CisJICogY2FzZSAyICAgPiAgfCAgICAgICAgICAg
PCB8CisJICogY2FzZSAzICAgICAgfCAgPiAgICAgICAgPCB8CisJICogY2FzZSA0ICAgICAg
fCAgPiAgICAgICAgICB8ICA8CisJICovCisKKwlpZiAoKHN0YXJ0IDw9IHZkc29fYmFzZSAm
JiB2ZHNvX2VuZCA8PSBlbmQpIHx8ICAvKiAxICAgKi8KKwkgICAgKHZkc29fYmFzZSA8PSBz
dGFydCAmJiBzdGFydCA8IHZkc29fZW5kKSB8fCAvKiAzLDQgKi8KKwkgICAgKHZkc29fYmFz
ZSA8IGVuZCAmJiBlbmQgPD0gdmRzb19lbmQpKSAgICAgICAvKiAyLDMgKi8KKwkJbW0tPmNv
bnRleHQudmRzb19iYXNlID0gbW0tPmNvbnRleHQudmRzb19lbmQgPSAwOwogfQogCiBzdGF0
aWMgaW5saW5lIHZvaWQgYXJjaF9icHJtX21tX2luaXQoc3RydWN0IG1tX3N0cnVjdCAqbW0s
CmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL21tdS00
MHguaCBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ub2hhc2gvMzIvbW11LTQweC5oCmlu
ZGV4IDc0ZjRlZGI1OTE2ZS4uOTg3MzliYTlkMzZlIDEwMDY0NAotLS0gYS9hcmNoL3Bvd2Vy
cGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL21tdS00MHguaAorKysgYi9hcmNoL3Bvd2VycGMv
aW5jbHVkZS9hc20vbm9oYXNoLzMyL21tdS00MHguaApAQCAtNTcsNyArNTcsNyBAQAogdHlw
ZWRlZiBzdHJ1Y3QgewogCXVuc2lnbmVkIGludAlpZDsKIAl1bnNpZ25lZCBpbnQJYWN0aXZl
OwotCXVuc2lnbmVkIGxvbmcJdmRzb19iYXNlOworCXVuc2lnbmVkIGxvbmcJdmRzb19iYXNl
LCB2ZHNvX2VuZDsKIH0gbW1fY29udGV4dF90OwogCiAjZW5kaWYgLyogIV9fQVNTRU1CTFlf
XyAqLwpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL25vaGFzaC8zMi9t
bXUtNDR4LmggYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL21tdS00NHgu
aAppbmRleCAyOGFhM2IzMzljNWUuLmRlMWQ1YjFjOGNlYyAxMDA2NDQKLS0tIGEvYXJjaC9w
b3dlcnBjL2luY2x1ZGUvYXNtL25vaGFzaC8zMi9tbXUtNDR4LmgKKysrIGIvYXJjaC9wb3dl
cnBjL2luY2x1ZGUvYXNtL25vaGFzaC8zMi9tbXUtNDR4LmgKQEAgLTEwOCw3ICsxMDgsNyBA
QCBleHRlcm4gdW5zaWduZWQgaW50IHRsYl80NHhfaW5kZXg7CiB0eXBlZGVmIHN0cnVjdCB7
CiAJdW5zaWduZWQgaW50CWlkOwogCXVuc2lnbmVkIGludAlhY3RpdmU7Ci0JdW5zaWduZWQg
bG9uZwl2ZHNvX2Jhc2U7CisJdW5zaWduZWQgbG9uZwl2ZHNvX2Jhc2UsIHZkc29fZW5kOwog
fSBtbV9jb250ZXh0X3Q7CiAKIC8qIHBhdGNoIHNpdGVzICovCmRpZmYgLS1naXQgYS9hcmNo
L3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL21tdS04eHguaCBiL2FyY2gvcG93ZXJw
Yy9pbmNsdWRlL2FzbS9ub2hhc2gvMzIvbW11LTh4eC5oCmluZGV4IDc2YWY1YjBjYjE2ZS4u
NDE0Y2U2NjM4YjIwIDEwMDY0NAotLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9o
YXNoLzMyL21tdS04eHguaAorKysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNo
LzMyL21tdS04eHguaApAQCAtMjA5LDcgKzIwOSw3IEBAIHN0cnVjdCBzbGljZV9tYXNrIHsK
IHR5cGVkZWYgc3RydWN0IHsKIAl1bnNpZ25lZCBpbnQgaWQ7CiAJdW5zaWduZWQgaW50IGFj
dGl2ZTsKLQl1bnNpZ25lZCBsb25nIHZkc29fYmFzZTsKKwl1bnNpZ25lZCBsb25nIHZkc29f
YmFzZSwgdmRzb19lbmQ7CiAjaWZkZWYgQ09ORklHX1BQQ19NTV9TTElDRVMKIAl1MTYgdXNl
cl9wc2l6ZTsJCS8qIHBhZ2Ugc2l6ZSBpbmRleCAqLwogCXVuc2lnbmVkIGNoYXIgbG93X3Ns
aWNlc19wc2l6ZVtTTElDRV9BUlJBWV9TSVpFXTsKZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJw
Yy9pbmNsdWRlL2FzbS9ub2hhc2gvbW11LWJvb2szZS5oIGIvYXJjaC9wb3dlcnBjL2luY2x1
ZGUvYXNtL25vaGFzaC9tbXUtYm9vazNlLmgKaW5kZXggNGM5Nzc3ZDI1NmZiLi44ZjQwNmFk
OWZlMjUgMTAwNjQ0Ci0tLSBhL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ub2hhc2gvbW11
LWJvb2szZS5oCisrKyBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ub2hhc2gvbW11LWJv
b2szZS5oCkBAIC0yMjksNyArMjI5LDcgQEAgZXh0ZXJuIHVuc2lnbmVkIGludCB0bGJjYW1f
aW5kZXg7CiB0eXBlZGVmIHN0cnVjdCB7CiAJdW5zaWduZWQgaW50CWlkOwogCXVuc2lnbmVk
IGludAlhY3RpdmU7Ci0JdW5zaWduZWQgbG9uZwl2ZHNvX2Jhc2U7CisJdW5zaWduZWQgbG9u
Zwl2ZHNvX2Jhc2UsIHZkc29fZW5kOwogfSBtbV9jb250ZXh0X3Q7CiAKIC8qIFBhZ2Ugc2l6
ZSBkZWZpbml0aW9ucywgY29tbW9uIGJldHdlZW4gMzIgYW5kIDY0LWJpdApkaWZmIC0tZ2l0
IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC92ZHNvLmMgYi9hcmNoL3Bvd2VycGMva2VybmVsL3Zk
c28uYwppbmRleCBhMzFiNjIzNGZjZDcuLjI2M2Y4MjBjYzY2NiAxMDA2NDQKLS0tIGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC92ZHNvLmMKKysrIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC92ZHNv
LmMKQEAgLTE4Miw2ICsxODIsNyBAQCBpbnQgYXJjaF9zZXR1cF9hZGRpdGlvbmFsX3BhZ2Vz
KHN0cnVjdCBsaW51eF9iaW5wcm0gKmJwcm0sIGludCB1c2VzX2ludGVycCkKICNlbmRpZgog
CiAJY3VycmVudC0+bW0tPmNvbnRleHQudmRzb19iYXNlID0gMDsKKwljdXJyZW50LT5tbS0+
Y29udGV4dC52ZHNvX2VuZCA9IDA7CiAKIAkvKiB2RFNPIGhhcyBhIHByb2JsZW0gYW5kIHdh
cyBkaXNhYmxlZCwganVzdCBkb24ndCAiZW5hYmxlIiBpdCBmb3IgdGhlCiAJICogcHJvY2Vz
cwpAQCAtMjE3LDYgKzIxOCw3IEBAIGludCBhcmNoX3NldHVwX2FkZGl0aW9uYWxfcGFnZXMo
c3RydWN0IGxpbnV4X2JpbnBybSAqYnBybSwgaW50IHVzZXNfaW50ZXJwKQogCSAqIHdpbGwg
ZmFpbCB0byByZWNvZ25pc2UgaXQgYXMgYSB2RFNPIChzaW5jZSBhcmNoX3ZtYV9uYW1lIGZh
aWxzKS4KIAkgKi8KIAljdXJyZW50LT5tbS0+Y29udGV4dC52ZHNvX2Jhc2UgPSB2ZHNvX2Jh
c2U7CisJY3VycmVudC0+bW0tPmNvbnRleHQudmRzb19lbmQgPSB2ZHNvX2Jhc2UgKyAodmRz
b19wYWdlcyA8PCBQQUdFX1NISUZUKTsKIAogCS8qCiAJICogb3VyIHZtYSBmbGFncyBkb24n
dCBoYXZlIFZNX1dSSVRFIHNvIGJ5IGRlZmF1bHQsIHRoZSBwcm9jZXNzIGlzbid0Ci0tIAoy
LjIxLjAKCg==
--------------DB04FC2ECDCA90F932F2D5E3--

