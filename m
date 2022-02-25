Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBF54C3E6E
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 07:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbiBYGee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 01:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiBYGed (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 01:34:33 -0500
X-Greylist: delayed 497 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 22:33:59 PST
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 0CA3F269297;
        Thu, 24 Feb 2022 22:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pku.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=cd1GW93tBI2kIBPDeF9M9y9aP+q7YS9rT4uQ
        Mk9plc8=; b=b39gchF8YXboirv8nb20yp63EnmKb1e5tDhxoA2TlR1WIhXx0c1b
        +JecD0QAPfJ+Zkr5QOKB8bZz1yBHKiJ/eRi7RWr9D3zHvkgxdcHM2vFl7MYGwkU6
        EcMGt3jPPIe6czOMXsZgtTb0QUbutvBQtbPitdYP1XbPhg/6eQ/2Scg=
Received: by ajax-webmail-front01 (Coremail) ; Fri, 25 Feb 2022 14:25:10
 +0800 (GMT+08:00)
X-Originating-IP: [10.129.19.172]
Date:   Fri, 25 Feb 2022 14:25:10 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5YiY5rC45b+X?= <lyz_cs@pku.edu.cn>
To:     "pavel machek" <pavel@denx.de>
Cc:     "sasha levin" <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "vinod koul" <vkoul@kernel.org>,
        christophe.jaillet@wanadoo.fr, arnd@arndb.de,
        laurent.pinchart@ideasonboard.com, dmaengine@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
 imbalance on error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-1ea67e80-64e4-49d5-bd9f-3beeae24b9f2-pku.edu.cn
In-Reply-To: <20220224223908.GA6522@duo.ucw.cz>
References: <20220223022820.240649-1-sashal@kernel.org>
 <20220223022820.240649-24-sashal@kernel.org>
 <20220224223908.GA6522@duo.ucw.cz>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <12bdb8e2.89509.17f2f8e0337.Coremail.lyz_cs@pku.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: 5oFpogBXOrhGdhhiloYiAg--.1378W
X-CM-SenderInfo: irzqijirqukmo6sn3hxhgxhubq/1tbiAwEIBlPy7uUuEAAAsY
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tCj4g5Y+R5Lu25Lq6OiAiUGF2ZWwgTWFjaGVrIiA8cGF2
ZWxAZGVueC5kZT4KPiDlj5HpgIHml7bpl7Q6IDIwMjItMDItMjUgMDY6Mzk6MDggKOaYn+acn+S6
lCkKPiDmlLbku7bkuro6ICJTYXNoYSBMZXZpbiIgPHNhc2hhbEBrZXJuZWwub3JnPgo+IOaKhOmA
gTogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZywgc3RhYmxlQHZnZXIua2VybmVsLm9yZywg
Illvbmd6aGkgTGl1IiA8bHl6X2NzQHBrdS5lZHUuY24+LCAiVmlub2QgS291bCIgPHZrb3VsQGtl
cm5lbC5vcmc+LCBjaHJpc3RvcGhlLmphaWxsZXRAd2FuYWRvby5mciwgYXJuZEBhcm5kYi5kZSwg
bGF1cmVudC5waW5jaGFydEBpZGVhc29uYm9hcmQuY29tLCBkbWFlbmdpbmVAdmdlci5rZXJuZWwu
b3JnCj4g5Li76aKYOiBSZTogW1BBVENIIEFVVE9TRUwgNS4xNiAyNC8zMF0gZG1hZW5naW5lOiBz
aGRtYTogRml4IHJ1bnRpbWUgUE0gaW1iYWxhbmNlIG9uIGVycm9yCj4gCj4gSGkhCj4gCj4gPiBG
cm9tOiBZb25nemhpIExpdSA8bHl6X2NzQHBrdS5lZHUuY24+Cj4gPiAKPiA+IFsgVXBzdHJlYW0g
Y29tbWl0IDQ1NTg5NmM1M2Q1YjgwMzczM2RkZDg0ZTFiZjhhNDMwNjQ0NDM5YjYgXQo+ID4gCj4g
PiBwbV9ydW50aW1lX2dldF8oKSBpbmNyZW1lbnRzIHRoZSBydW50aW1lIFBNIHVzYWdlIGNvdW50
ZXIgZXZlbgo+ID4gd2hlbiBpdCByZXR1cm5zIGFuIGVycm9yIGNvZGUsIHRodXMgYSBtYXRjaGlu
ZyBkZWNyZW1lbnQgaXMgbmVlZGVkIG9uCj4gPiB0aGUgZXJyb3IgaGFuZGxpbmcgcGF0aCB0byBr
ZWVwIHRoZSBjb3VudGVyIGJhbGFuY2VkLgo+IAo+IEkgZG9uJ3QgdGhpbmsgdGhhdCdzIHJpZ2h0
Lgo+IAo+IE5vdGljZSB0aGF0IC1yZXQgaXMgaWdub3JlZCAoY2hlY2tlZCA0LjQgYW5kIDUuMTAp
LCBzbyB3ZSBkb24ndAo+IGFjdHVhbGx5IGFib3J0L3JldHVybiBlcnJvcjsgd2UganVzdCBwcmlu
dGsuIFdlJ2xsIGRvIHR3bwo+IHBtX3J1bnRpbWVfcHV0J3MgYWZ0ZXIgdGhlICJmaXgiLgoKVGhh
bmsgeW91IHZlcnkgbXVjaCBmb3IgdGhlIGNvcnJlY3Rpb24uIEkgYW0gdmVyeSBzb3JyeSB0aGF0
IEkgY2F1c2VkIHlvdSB1bm5lY2Vzc2FyeSB0cm91YmxlIGJlY2F1c2Ugb2YgbXkgY2FyZWxlc3Nu
ZXNzLgpUaGUgcG1fcnVudGltZV9wdXQgaXMgaW5kZWVkIGNhbGxlZCBsYXRlciBpbiBfX2xkX2Ns
ZWFudXAsIHNvIG9ubHkgcHJpbnRrIGlzIG5lZWRlZCBhdCAtcmV0IGFuZCB0aGUgcGF0Y2ggaXMg
bm90IHJpZ2h0LgoKPiAKPiBQbGVhc2UgZHJvcCBmcm9tIC1zdGFibGUuCj4gCj4gQmVzdCByZWdh
cmRzLAo+IAkJCQkJCQkJUGF2ZWwKPiAtLSAKPiBERU5YIFNvZnR3YXJlIEVuZ2luZWVyaW5nIEdt
YkgsICAgICAgTWFuYWdpbmcgRGlyZWN0b3I6IFdvbGZnYW5nIERlbmsKPiBIUkIgMTY1MjM1IE11
bmljaCwgT2ZmaWNlOiBLaXJjaGVuc3RyLjUsIEQtODIxOTQgR3JvZWJlbnplbGwsIEdlcm1hbnkK

