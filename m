Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61B65601C0
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiF2Nxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 09:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiF2Nxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 09:53:39 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 06:53:37 PDT
Received: from m1564.mail.126.com (m1564.mail.126.com [220.181.15.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABE491A836;
        Wed, 29 Jun 2022 06:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=FJN4I
        IbVkQdw9+cImUILX4gQzGLXp9vFfQmdhbPysgE=; b=dVoaWrZh4suHy0tJGo7kI
        PpzTqENRgd/LVSYfzLNomZ0Npj+5E6W6nrXZ0AiMlWQ4kf8E+aU4mSLy0UaIvZPO
        ucJNjdC9t+2PFaFDS/PIfTqmsFym0QT5nRlc43+mYg5KUVJvyzlqLXjinaeLf4rf
        M+zk2809E6eLGyLH/c+dHA=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr64
 (Coremail) ; Wed, 29 Jun 2022 21:23:01 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Wed, 29 Jun 2022 21:23:01 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Pavel Machek" <pavel@denx.de>
Cc:     "Sasha Levin" <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        yangtiezhu@loongson.cn, linux-mips@vger.kernel.org
Subject: Re:Re: [PATCH AUTOSEL 4.9 11/13] mips/pic32/pic32mzda: Fix refcount
 leak bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220629130617.GE13395@duo.ucw.cz>
References: <20220628022657.597208-1-sashal@kernel.org>
 <20220628022657.597208-11-sashal@kernel.org>
 <20220629130617.GE13395@duo.ucw.cz>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <120f6850.7be3.181afa11f50.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMqowAAnL3M2UrxiBCNCAA--.29325W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGg4vF1-HZZ+vqAAAsJ
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgoKCkF0IDIwMjItMDYtMjkgMjE6MDY6MTcsICJQYXZlbCBNYWNoZWsiIDxwYXZlbEBkZW54LmRl
PiB3cm90ZToKPkhpIQo+Cj4+IEZyb206IExpYW5nIEhlIDx3aW5kaGxAMTI2LmNvbT4KPj4gCj4+
IFsgVXBzdHJlYW0gY29tbWl0IGViOWU5YmM0ZmE1ZmI0ODljOTJlYzU4OGIzZmIzNWYwNDJiYTZk
ODYgXQo+PiAKPj4gb2ZfZmluZF9tYXRjaGluZ19ub2RlKCksIG9mX2ZpbmRfY29tcGF0aWJsZV9u
b2RlKCkgYW5kCj4+IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCkgd2lsbCByZXR1cm4gbm9kZSBwb2lu
dGVycyB3aXRoIHJlZmNvdXQKPj4gaW5jcmVtZW50ZWQuIFdlIHNob3VsZCBjYWxsIG9mX25vZGVf
cHV0KCkgd2hlbiB0aGV5IGFyZSBub3QKPj4gdXNlZCBhbnltb3JlLgo+Cj5JdCBsb29rcyBsaWtl
IHRoaXMgbWF5IGludHJvZHVjZXMgYW4gdXNlLWFmdGVyLWZyZWUgYnVnOgo+Cj4+ICsrKyBiL2Fy
Y2gvbWlwcy9waWMzMi9waWMzMm16ZGEvaW5pdC5jCj4+IEBAIC0xMzEsMTMgKzEzMSwxOCBAQCBz
dGF0aWMgaW50IF9faW5pdCBwaWMzMl9vZl9wcmVwYXJlX3BsYXRmb3JtX2RhdGEoc3RydWN0IG9m
X2Rldl9hdXhkYXRhICpsb29rdXApCj4+ICAJCW5wID0gb2ZfZmluZF9jb21wYXRpYmxlX25vZGUo
TlVMTCwgTlVMTCwgbG9va3VwLT5jb21wYXRpYmxlKTsKPj4gIAkJaWYgKG5wKSB7Cj4+ICAJCQls
b29rdXAtPm5hbWUgPSAoY2hhciAqKW5wLT5uYW1lOwo+PiAtCQkJaWYgKGxvb2t1cC0+cGh5c19h
ZGRyKQo+PiArCQkJaWYgKGxvb2t1cC0+cGh5c19hZGRyKSB7Cj4+ICsJCQkJb2Zfbm9kZV9wdXQo
bnApOwo+PiAgCQkJCWNvbnRpbnVlOwo+PiArCQkJfQo+PiAgCQkJaWYgKCFvZl9hZGRyZXNzX3Rv
X3Jlc291cmNlKG5wLCAwLCAmcmVzKSkKPj4gIAkJCQlsb29rdXAtPnBoeXNfYWRkciA9IHJlcy5z
dGFydDsKPj4gKwkJCW9mX25vZGVfcHV0KG5wKTsKPj4gIAkJfQo+PiAgCX0KPgo+bG9va3VwLT5u
YW1lIG5vdyBjb250YWlucyBwb2ludGVyIHRha2VuIGZyb20gbnAtPm5hbWUsIGJ1dCB3ZSBkaWQK
PnB1dCgpIG9uIHRoZSBucC4gV2hhdCBndWFyYW50ZWVzIG5wLT5uYW1lIGlzIG5vdCBmcmVlZD8K
Pgo+QmVzdCByZWdhcmRzLAo+CQkJCQkJCQlQYXZlbAoKSGksIFBhdmVsLgoKVGhhbmtzIGZvciB5
b3UgdG8gcmV2aWV3IHRoaXMgcGF0Y2hlZCBjb2RlLgoKSW4gZmFjdCwgdGhlIHxQVVR8IG9uICdu
cCcgd2lsbCBub3QgbGVhZCB0byB0aGUgfEZSRUV8LgpGaXJzdCwgYmVmb3JlIGNhbGxpbmcgb2Zf
ZmluZF9jb21wYXRpYmxlX25vZGUoKSwgdGhlIHRhcmdldCBvYmplY3QncyByZWZjb3VudCBtdXN0
IGJlID49IDEsIGFzIHRoZSBvYmplY3QgaXMgYWxpdmUuClRoZW4sIGFmdGVyIGNhbGxpbmcgb2Zf
ZmluZF9jb21wYXRpYmxlX25vZGUoKSwgaXRzIHJlZmNvdW50IG11c3QgYmUgPj0yLgpTbywgYWZ0
ZXIgY2FsbGluZyBvZl9ub2RlX3B1dChucCksIGl0cyByZWZjb3VudCBtdXN0IGJlIHN0aWxsID49
MS4KCkluIGZhY3QsIHRoZXNlIHxQVVR8cyBhcmUganVzdCB1c2VkIHRvIGtlZXAgcmVmY291bnQg
YmFsYW5jZSBmb3IgdGhlIHxHRVR8IGluIG9mX2ZpbmRfY29tcGF0aWJsZV9ub2RlKCkuCgpJZiB0
aGVyZSBpcyBhbnl0aGluZyB3cm9uZywgcGxlYXNlIGNvcnJlY3QgbWUuCgpUaGFucyB2ZXJ5IG11
Y2ggdG8gcmV2aWV3IG15IHBhdGNoIGNvZGUuCgpMaWFuZwoKPi0tIAo+REVOWCBTb2Z0d2FyZSBF
bmdpbmVlcmluZyBHbWJILCAgICAgIE1hbmFnaW5nIERpcmVjdG9yOiBXb2xmZ2FuZyBEZW5rCj5I
UkIgMTY1MjM1IE11bmljaCwgT2ZmaWNlOiBLaXJjaGVuc3RyLjUsIEQtODIxOTQgR3JvZWJlbnpl
bGwsIEdlcm1hbnkK
