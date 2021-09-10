Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A834070C8
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhIJSHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 14:07:53 -0400
Received: from mout.gmx.net ([212.227.17.21]:56217 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhIJSHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 14:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631297194;
        bh=jW448sTpnZDFN8QUPHirb3j8PtdVPnlNAfzumAnRlCg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Sau4UFrV1U7CBrV2HCXYodO7ioryBw4nIq8GJ1aaA8kqGW8lpg3L+MjQlvtGVDHXn
         wUkJNohBXkfHLtF0JztEhkYssG06zefT0J2BYPiPcslOfLp9sgJZklUrIxeF7CrRH+
         XGxY1JOiQl7rixTkCThbeODPA2uS4X0uaW05SUYw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([46.223.119.124]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MI5QF-1mBqLm3a35-00FDr0; Fri, 10
 Sep 2021 20:06:33 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca
Cc:     p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, stable@vger.kernel.org
Subject: [PATCH] tpm: fix potential NULL pointer access in tpm_del_char_device()
Date:   Fri, 10 Sep 2021 20:04:51 +0200
Message-Id: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:0DM/eQqN4B/1MK1yjszEd9wMzscabNNp2hctTNBF7BDsN95RFlQ
 QWE+gJIP3x2739QCpvtIJzyyKQZIzXFtI+jVuMjK0ACVMwqJeyhljcXOjcafP4jygrwv5FG
 nFJdANsr9U5EmnW1j7ECFEpNwqp2bIDwvVO4VQMLeGWOcDscODIK9lUSI0ILISyt+yGZNGs
 AMYUpbrDi7PQlra3XfsEA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ddwqrUnKMt8=:c+XWJ89mC6OfwVzn2Fp3SF
 3+8f26ajiFtiXxhy2grMmNV7HAVKIztaqu3nDu/fzeOruDBRnDbXB5GkHHjbB3hRZ4X55fEQS
 /pfw1aihg5hbhoCStwl1T5VjRVatXP2Qy9fULL2ZseY+w8gL0IYaLUhxRxZ4iVZGA2tdEv6Z/
 batx1CS4Vvruaz/UnQb0w14eeJCAbdOH8or9yLAwPrdtTvvqMM8Ly9/0U/UH+8EQL7Wst/1m4
 a89UlXwDXdPyBFYUI185mf54o2IOCn85gDP3r8N2eAyD8ZbJ3zpA2L0ZFrbZI3QF8EQ5LCkta
 OAMzN0OJ7mlqYrzmahKYEOwYXQ+FyHoIv+5VvKm5jAdDjftAf6B0VNpo1B7uxgDbM1JqU8XBe
 MqVTj7vrDHZdD0UHInRDiRJ7lFJYOKRZjnfM5VwgTLQcMhfzhwVJQGpaoJu97egPJiwQzEUOo
 WoQ6SE6P2woWqYbeB3JRpF9VW612yGhpOBlYPS3bFjXKlnsjn7prv5ktAuYRfPJAOfeQ3SYdB
 qfPDwEYn0oTlZEu3TE2LZJqEHzTyeQBXz+C5QTrI0htPbfp9np5kM4jlLLEVHXaCDOh8fI8IQ
 W/EWIR1iQJzTmyi7RNztB3sK6Cxy7i7FKctbsOm+BKzyZL77h5GdAYdA2iZaItfXwQetZIx19
 JU46aPgPUTL8lR6d3hC0Ud3NptyvKK5pd5nI4/xjsLvIjDCc+QdzeqlNVL6tZjLimCJXsaIoQ
 4zpGnQQbVyz1Q7gEFV/Axm22E3NhhVOKZRFX6Ce/8RMqbToaVKi0SDGb5ldETbkOHIxunjoF8
 PC9XNtBLhyXSbgX+kux5HCLD2xLKh4yHgKNH3kEEgqPR0YZs08PKGstkoKItVGT005jSZfwyB
 DA9bSYDwb8hH7BQ0vezqG2HAEJ2TJXKRb1c0Slzante9+KYJlnV2uBCPHvhVVtSxsquTlDmvr
 HmQTJQbt20P43DHDuUaWf1fgjMZaPQCnJ+dWH7shitjDHwmC9bk5EL3G91r8ghwTZcKv8akLC
 wyHBAf8A1vdiR5qH2+JzBe3a5PW6OBMz7lL95gX/Dl1FRwroKaYy6XFytyPTH3rGHd6cKQfF/
 SwnfjOIRrY6N6g=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SW4gdHBtX2RlbF9jaGFyX2RldmljZSgpIG1ha2Ugc3VyZSB0aGF0IGNoaXAtPm9wcyBpcyBzdGls
bCB2YWxpZC4KVGhpcyBjaGVjayBpcyBuZWVkZWQgc2luY2UgaW4gY2FzZSBvZiBhIHN5c3RlbSBz
aHV0ZG93bgp0cG1fY2xhc3Nfc2h1dGRvd24oKSBoYXMgYWxyZWFkeSBiZWVuIGNhbGxlZCBhbmQg
c2V0IGNoaXAtPm9wcyB0byBOVUxMLgpUaGlzIGxlYWRzIHRvIGEgTlVMTCBwb2ludGVyIGFjY2Vz
cyBhcyBzb29uIGFzIHRwbV9kZWxfY2hhcl9kZXZpY2UoKQp0cmllcyB0byBhY2Nlc3MgY2hpcC0+
b3BzIGluIGNhc2Ugb2YgVFBNIDIuCgpGaXhlczogZGNiZWFiMTk0NjQ1NCAoInRwbTogZml4IGNy
YXNoIGluIHRwbV90aXMgZGVpbml0aWFsaXphdGlvbiIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnClNpZ25lZC1vZmYtYnk6IExpbm8gU2FuZmlsaXBwbyA8TGlub1NhbmZpbGlwcG9AZ214LmRl
PgotLS0KIGRyaXZlcnMvY2hhci90cG0vdHBtLWNoaXAuYyB8IDE2ICsrKysrKysrKysrLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY2hhci90cG0vdHBtLWNoaXAuYyBiL2RyaXZlcnMvY2hhci90cG0vdHBt
LWNoaXAuYwppbmRleCBkZGFlY2ViN2UxMDkuLmVkMWZiNWQ4MmNhZiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9jaGFyL3RwbS90cG0tY2hpcC5jCisrKyBiL2RyaXZlcnMvY2hhci90cG0vdHBtLWNoaXAu
YwpAQCAtNDc0LDEzICs0NzQsMTkgQEAgc3RhdGljIHZvaWQgdHBtX2RlbF9jaGFyX2RldmljZShz
dHJ1Y3QgdHBtX2NoaXAgKmNoaXApCiAKIAkvKiBNYWtlIHRoZSBkcml2ZXIgdW5jYWxsYWJsZS4g
Ki8KIAlkb3duX3dyaXRlKCZjaGlwLT5vcHNfc2VtKTsKLQlpZiAoY2hpcC0+ZmxhZ3MgJiBUUE1f
Q0hJUF9GTEFHX1RQTTIpIHsKLQkJaWYgKCF0cG1fY2hpcF9zdGFydChjaGlwKSkgewotCQkJdHBt
Ml9zaHV0ZG93bihjaGlwLCBUUE0yX1NVX0NMRUFSKTsKLQkJCXRwbV9jaGlwX3N0b3AoY2hpcCk7
CisJLyogQ2hlY2sgaWYgY2hpcC0+b3BzIGlzIHN0aWxsIHZhbGlkIHNpbmNlIGluIGNhc2Ugb2Yg
YSBzaHV0ZG93bgorCSAqIHRwbV9jbGFzc19zaHV0ZG93bigpIGhhcyBhbHJlYWR5IHNlbnQgdGhl
IFRQTTJfU2h1dGRvd24gY29tbWFuZAorCSAqIGFuZCBzZXQgY2hpcC0+b3BzIHRvIE5VTEwuCisJ
ICovCisJaWYgKGNoaXAtPm9wcykgeworCQlpZiAoY2hpcC0+ZmxhZ3MgJiBUUE1fQ0hJUF9GTEFH
X1RQTTIpIHsKKwkJCWlmICghdHBtX2NoaXBfc3RhcnQoY2hpcCkpIHsKKwkJCQl0cG0yX3NodXRk
b3duKGNoaXAsIFRQTTJfU1VfQ0xFQVIpOworCQkJCXRwbV9jaGlwX3N0b3AoY2hpcCk7CisJCQl9
CiAJCX0KKwkJY2hpcC0+b3BzID0gTlVMTDsKIAl9Ci0JY2hpcC0+b3BzID0gTlVMTDsKIAl1cF93
cml0ZSgmY2hpcC0+b3BzX3NlbSk7CiB9CiAKCmJhc2UtY29tbWl0OiBhM2ZhN2ExMDFkY2ZmOTM3
OTFkMWIxYmRiM2FmZmNhZDE0MTBjOGMxCi0tIAoyLjMzLjAKCg==
