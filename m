Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9A44D7082
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 20:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiCLTI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 14:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiCLTI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 14:08:26 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D5421046D
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 11:07:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id q76-20020a25d94f000000b00628bdf8d1a9so10167571ybg.17
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 11:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=TWhUcEhJnfBz1oTu7BiAWZwmJa9vzrkYnnSYzliORuM=;
        b=YlL5wbo0sMKLZYKtJvoEY2SZ/FFC4zjf4E0ldQCYpcuQWiSq6tThSfLpZXtjOymvO0
         zjD3DkgKcLDthdXByQmLr8kU7NGYUeJEJvN6F72GWhtz78HJQP3DpFshdY24SfaMxjTG
         7pZXfq6bIgmxKpXHWte/pr0AuKz9s7VSgoSOYQV9ArZz4sLdjMS02gBMIDzBOMSLAc0Z
         TMLehhLhzoWfUkvUQlwiq8mqeYokM5OOjt2YEjn9JhOva+1q+pW6zbdO7xwq/TWpwrr7
         cCMi+uWUnhod11KQWTTeZtHhhean/gyxtSr+o2uRczHcH3q3JKX5gXFcwtUTWcPywtRY
         rN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=TWhUcEhJnfBz1oTu7BiAWZwmJa9vzrkYnnSYzliORuM=;
        b=q1cVoAdeHRxkp3aVt7DNAYzJpJJ67XBuTpBrLu7LY0VdIMDmiNiPrHmW+jLZdfRi1Q
         ZqP2VKbN/rkJTV7ZffJ8H4o6SOpP2wZ/gYHIT7ludC94lDCSaprMDrVrblznZds5RfDQ
         HlmQ9BCKQDoMZpuJXhcFvb4OeFuH2Dhx5VLPrvQyGfzEmUgu7xGDe25o8Y94q46cX1qQ
         bWK1aNhFdATNUgKFixbWfMKvzBPvvKZHtVUL5XAtMAPZygp7kki65+VqwI9Pwrv23k/b
         o8eoSQf6kH0jGgv9F7Z6km4Dlrnl2WIIN7XMMoN7bCRtRSzhrHysGXyk5J4H1EhDnysD
         8jdA==
X-Gm-Message-State: AOAM533wZGPqdEEoORspi0Py9zYRMelubSkzLIwtJ8tS74wUEo4Jls4p
        x8KHtSsAegqkbnNU8FtdmfSonHtZ+BDM5Q==
X-Google-Smtp-Source: ABdhPJwITP06nQ15VGDrmQ7iJQEv8VZmDxnDgedrPCcT4HTXkkjfvihJapSTTwUJvrBPMzqDl48d/4QpM97lSA==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a25:698d:0:b0:628:79c5:e4c5 with SMTP id
 e135-20020a25698d000000b0062879c5e4c5mr12094300ybc.574.1647112038218; Sat, 12
 Mar 2022 11:07:18 -0800 (PST)
Date:   Sat, 12 Mar 2022 19:07:15 +0000
In-Reply-To: <20220311160051.GA24796@blackbody.suse.cz>
Message-Id: <20220312190715.cx4aznnzf6zdp7wv@google.com>
Mime-Version: 1.0
References: <20220304184040.1304781-1-shakeelb@google.com> <20220311160051.GA24796@blackbody.suse.cz>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
From:   Shakeel Butt <shakeelb@google.com>
To:     "Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Ivan Babrou <ivan@cloudflare.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWljaGFsLA0KDQpPbiBGcmksIE1hciAxMSwgMjAyMiBhdCAwNTowMDo1MVBNICswMTAwLCBN
aWNoYWwgS291dG7DvSB3cm90ZToNCj4gSGVsbG8uDQoNCj4gVEw7RFIgcnN0YXRzIGFyZSBzbG93
IGJ1dCBhY2N1cmF0ZSBvbiByZWFkZXIgc2lkZS4gVG8gdGFja2xlIHRoZQ0KPiBwZXJmb3JtYW5j
ZSByZWdyZXNzaW9uIG5vIGZsdXNoIHNlZW1zIHNpbXBsZXIgdGhhbiB0aGlzIHBhdGNoLg0KDQoN
ClRoZSB0ZXJtICdzaW1wbGVyJyBpcyB2ZXJ5IHN1YmplY3RpdmUgaGVyZSBhbmQgSSB3b3VsZCBh
cmd1ZSB0aGlzIHBhdGNoDQppcyBub3QgdGhhdCBjb21wbGljYXRlZCB0aGFuIG5vIGZsdXNoIGJ1
dCBJIHRoaW5rIHRoZXJlIGlzIG5vIGJlbmVmaXQgb24NCmFyZ3Vpbmcgb24gdGhpcyBhcyB0aGVz
ZSBhcmUgbm90IHNvbWUgc3RhYmxlIEFQSSB3aGljaCBjYW4gbm90IGJlDQpjaGFuZ2VkIGxhdGVy
LiBXZSBjYW4gYWx3YXlzIGNvbWUgYmFjayBhbmQgY2hhbmdlIGJhc2VkIG9uIG5ldyBmaW5kaW5n
cy4NCg0KQmVmb3JlIGdvaW5nIGZ1cnRoZXIsIEkgZG8gd2FudCB0byBtZW50aW9uIHRoZSBtYWlu
IHJlYXNvbiB0byBtb3ZlIHRvDQpyc3RhdCBpbmZyYXN0cnVjdHVyZSB3YXMgdG8gZGVjb3VwbGUg
dGhlIGVycm9yIHJhdGUgaW4gdGhlIHN0YXRzIGZyb20NCnRoZSBudW1iZXIgb2YgbWVtb3J5IGNn
cm91cHMgYW5kIHRoZSBudW1iZXIgb2Ygc3RhdCBpdGVtcy4gU28sIEkgd2lsbA0KZm9jdXMgb24g
dGhlIGVycm9yIHJhdGUgaW4gdGhpcyBlbWFpbC4NCg0KWy4uLl0NCg0KPiBUaGUgYmVuZWZpdCB0
aGlzIHdhcyB0cmFkZWQgZm9yIHdhcyB0aGUgZ3JlYXRlciBhY2N1cmFjeSwgdGhlIHBvc3NpYmxl
DQo+IGVycm9yIGlzOg0KPiAtIGJlZm9yZQ0KPiAgICAtIE8obnJfY3B1cyAqIG5yX2Nncm91cHMo
c3VidHJlZSkgKiBNRU1DR19DSEFSR0VfQkFUQ0gpCSgxKQ0KDQpQbGVhc2Ugbm90ZSB0aGF0ICgx
KSBpcyB0aGUgcG9zc2libGUgZXJyb3IgZm9yIGVhY2ggc3RhdCBpdGVtIGFuZA0Kd2l0aG91dCBh
bnkgdGltZSBib3VuZC4NCg0KPiAtIGFmdGVyDQo+ICAgICAgTyhucl9jcHVzICogTUVNQ0dfQ0hB
UkdFX0JBVENIKSAvLyBzeW5jLiBmbHVzaA0KDQpUaGUgYWJvdmUgaXMgYWNyb3NzIGFsbCB0aGUg
c3RhdCBpdGVtcy4NCg0KPiAgICAgIG9yDQo+ICAgICAgTyhmbHVzaF9wZXJpb2QgKiBtYXhfY3Ip
IC8vIHBlcmlvZGljIGZsdXNoIG9ubHkJCSgyKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAvLyBtYXhfY3IgaXMgcGVyLWNvdW50ZXIgbWF4IGNoYW5nZSByYXRlDQoNCkFuZCB0aGlz
IGFib3ZlIG9uZSwgSSBhbSBhc3N1bWluZywgaXMgZm9yIHBlcmZvcm1hbmNlIGNyaXRpY2FsIHJl
YWRlcnMNCih3b3JraW5nc2V0X3JlZmF1bHQgaW50cm9kdWNlZCBieSB0aGlzIHBhdGNoKSBhbmQg
Zmx1c2hfcGVyaW9kIGhlcmUgaXMgNA0Kc2Vjb25kcy4gUGxlYXNlIGNvcnJlY3QgbWUgaWYgSSBt
aXN1bmRlcnN0b29kIHRoaXMuDQoNCg0KPiBTbyB3ZSBjb3VsZCBhcmd1ZSB0aGF0IGlmIHRoZSBw
cmUtcnN0YXQga2VybmVscyBkaWQganVzdCBmaW5lIHdpdGggdGhlDQo+IGVycm9yICgxKSwgdGhl
eSB3b3VsZCBub3QgYmUgd29yc2Ugd2l0aCBwZXJpb2RpYyBmbHVzaCBpZiB3ZSBjYW4gY29tcGFy
ZQ0KPiAoMSkgYW5kICgyKS4NCg0KSSBhZ3JlZSB3aXRoIHRoaXMgYXNzZXNzbWVudCBidXQgcGxl
YXNlIG5vdGUgdGhhdCBwcmUtcnN0YXQga2VybmVscyB3ZXJlDQpub3QgZ29vZCBmb3IgbWFjaGlu
ZXMgd2l0aCBsYXJnZSBudW1iZXIgb2YgQ1BVcyBhbmQgcnVubmluZyBsYXJnZSBudW1iZXINCm9m
IHdvcmtsb2Fkcy4NCg0KWy4uLl0NCg0KPiBJJ20gbm90IHN1cmUgd2hldGhlciB5b3VyIHBhdGNo
IGF0dGVtcHRzIHRvIHNvbHZlIHRoZSBwcm9ibGVtIG9mDQo+IChhKSBwZXJpb2RpYyBmbHVzaCBn
ZXR0aW5nIHN0dWNrIG9yIChiKSBsaW1pdGluZyBlcnJvciBvbiByZWZhdWx0IHBhdGguDQo+IElm
IGl0J3MgKGEpLCBpdCBzaG91bGQgYmUgdGFja2xlZCBtb3JlIHN5c3RlbWF0aWNhbGx5IChkZWRp
Y2F0ZWQgd3E/KS4NCj4gSWYgaXQncyAoYiksIHdoeSBub3QganVzdCByZWx5IG9uIHBlcmlvZGlj
IGZsdXNoIChzZWxmIGFuc3dlcjogKDEpIGFuZA0KPiAoMikgY29tcGFyaXNvbiBpcyB3b3JrbG9h
ZCBkZXBlbmRlbnQpLg0KDQoNCkl0IGlzIChiKSB0aGF0IEkgYW0gYWltaW5nIGZvciBpbiB0aGlz
IHBhdGNoLiBBdCBsZWFzdCAoYSkgd2FzIG5vdA0KaGFwcGVuaW5nIGluIHRoZSBjbG91ZGZsYXJl
IGV4cGVyaW1lbnRzLiBBcmUgeW91IHN1Z2dlc3RpbmcgaGF2aW5nIGENCmRlZGljYXRlZCBoaWdo
IHByaW9yaXR5IHdxIHdvdWxkIHNvbHZlIGJvdGggKGEpIGFuZCAoYik/DQoNCj4gPiBOb3cgdGhl
IHF1ZXN0aW9uOiB3aGF0IGFyZSB0aGUgc2lkZS1lZmZlY3RzIG9mIHRoaXMgY2hhbmdlPyBUaGUg
d29yc3QNCj4gPiB0aGF0IGNhbiBoYXBwZW4gaXMgdGhlIHJlZmF1bHQgY29kZXBhdGggd2lsbCBz
ZWUgNHNlYyBvbGQgbHJ1dmVjIHN0YXRzDQo+ID4gYW5kIG1heSBjYXVzZSBmYWxzZSAob3IgbWlz
c2VkKSBhY3RpdmF0aW9ucyBvZiB0aGUgcmVmYXVsdGVkIHBhZ2Ugd2hpY2gNCj4gPiBtYXkgdW5k
ZXItb3Itb3ZlcmVzdGltYXRlIHRoZSB3b3JraW5nc2V0IHNpemUuIFRob3VnaCB0aGF0IGlzIG5v
dCB2ZXJ5DQo+ID4gY29uY2VybmluZyBhcyB0aGUga2VybmVsIGNhbiBhbHJlYWR5IG1pc3Mgb3Ig
ZG8gZmFsc2UgYWN0aXZhdGlvbnMuDQoNCj4gV2UgY2FuJ3QgYXJndWUgd2hhdCdzIHRoZSBlZmZl
Y3Qgb2YgcGVyaW9kaWMgb25seSBmbHVzaGluZyBzbyB0aGlzDQo+IG5ld2x5IGludHJvZHVjZWQg
ZmFjdG9yIHdvdWxkIGluaGVyaXQgdGhhdCB0b28uIEkgZmluZCBpdCBzdXBlcmZsdW91cy4NCg0K
DQpTb3JyeSBJIGRpZG4ndCBnZXQgeW91ciBwb2ludC4gV2hhdCBpcyBzdXBlcmZsdW91cz8NCg0K
DQo+IE1pY2hhbA0KDQo+IFsxXSBUaGlzIGlzIHdvcnRoIGxvb2tpbmcgYXQgaW4gbW9yZSBkZXRh
aWwuDQoNCg0KT2ggeW91IGRpZCBzb21lIGF3ZXNvbWUgYW5hbHlzaXMgaGVyZS4NCg0KPiAgRnJv
bSB0aGUgZmx1c2ggY29uZGl0aW9uIHdlIGhhdmUNCj4gICAgY3IgKiDOlHQgPSBucl9jcHVzICog
TUVNQ0dfQ0hBUkdFX0JBVENIDQo+IHdoZXJlIM6UdCBpcyB0aW1lIGJldHdlZW4gZmx1c2hlcyBh
bmQgY3IgaXMgZ2xvYmFsIGNoYW5nZSByYXRlLg0KDQo+IGNyIGNvbXBvc2VzIG9mIGFsbCB1cGRh
dGVzIHRvZ2V0aGVyIChjb3JyZXNwb25kcyB0byBzdGF0c191cGRhdGVzIGluDQo+IG1lbWNnX3Jz
dGF0X3VwZGF0ZWQoKSwgbWF4X2NyIGlzIGNoYW5nZSByYXRlIHBlciBjb3VudGVyKQ0KPiAgICBj
ciA9IM6jIGNyX2kgPD0gbnJfY291bnRlcnMgKiBtYXhfY3INCg0KSSBkb24ndCBnZXQgdGhlIHJl
YXNvbiBvZiBicmVha2luZyAnY3InIGludG8gaW5kaXZpZHVhbCBzdGF0IGl0ZW0gb3INCmNvdW50
ZXIuIFdoYXQgaXMgdGhlIGJlbmVmaXQ/IFdlIHdhbnQgdG8ga2VlcCB0aGUgZXJyb3IgcmF0ZSBk
ZWNvdXBsZWQNCmZyb20gdGhlIG51bWJlciBvZiBjb3VudGVycyAob3Igc3RhdCBpdGVtcykuDQoN
Cg0KPiBCeSBjb21iaW5pbmcgdGhlc2UgdHdvIHdlIGdldCBzaG9ydGVzdCB0aW1lIGJldHdlZW4g
Zmx1c2hlczoNCj4gICAgY3IgKiDOlHQgPD0gbnJfY291bnRlcnMgKiBtYXhfY3IgKiDOlHQNCj4g
ICAgbnJfY3B1cyAqIE1FTUNHX0NIQVJHRV9CQVRDSCA8PSBucl9jb3VudGVycyAqIG1heF9jciAq
IM6UdA0KPiAgICDOlHQgPj0gKG5yX2NwdXMgKiBNRU1DR19DSEFSR0VfQkFUQ0gpIC8gKG5yX2Nv
dW50ZXJzICogbWF4X2NyKQ0KDQo+IFdlIGFyZSBpbnRlcmVzdGVkIGluDQo+ICAgIFJfYW1vcnQg
PSBmbHVzaF93b3JrIC8gzpR0DQo+IHdoaWNoIGlzDQo+ICAgIFJfYW1vcnQgPD0gZmx1c2hfd29y
ayAqIG5yX2NvdW50ZXJzICogbWF4X2NyIC8gKG5yX2NwdXMgKiAgDQo+IE1FTUNHX0NIQVJHRV9C
QVRDSCkNCg0KPiBSX2Ftb3J0OiBPKCBucl9jcHVzICogbnJfY2dyb3VwcyhzdWJ0cmVlKSAqIG5y
X2NvdW50ZXJzICogKG5yX2NvdW50ZXJzICogIA0KPiBtYXhfY3IpIC8gKG5yX2NwdXMgKiBNRU1D
R19DSEFSR0VfQkFUQ0gpICkNCj4gUl9hbW9ydDogTyggbnJfY2dyb3VwcyhzdWJ0cmVlKSAqIG5y
X2NvdW50ZXJzXjIgKiBtYXhfY3IpIC8gIA0KPiAoTUVNQ0dfQ0hBUkdFX0JBVENIKSApDQoNCj4g
VGhlIHNxdWFyZSBsb29rcyBpbnRlcmVzdGluZyBnaXZlbiB0aGVyZSBhcmUgYWxyZWFkeSB0ZW5z
IG9mIGNvdW50ZXJzLg0KPiAoQXMgZGF0YSBmcm9tIEl2YW4gaGF2ZSBzaG93biwgd2UgY2FuIGhh
cmRseSByZXN0b3JlIHRoZSBwcmUtcnN0YXQNCj4gcGVyZm9ybWFuY2Ugb24gdGhlIHJlYWQgc2lk
ZSBldmVuIHdpdGggbWVyZSBtb2RfZGVsYXllZF93b3JrKCkuKQ0KPiBUaGlzIGlzIHdoYXQgeW91
IHBhcnRpYWxseSBzb2x2ZWQgd2l0aCBpbnRyb2R1Y3Rpb24gb2YgTlJfTUVNQ0dfRVZFTlRTDQoN
Ck15IG1haW4gcmVhc29uIGJlaGluZCB0cnlpbmcgTlJfTUVNQ0dfRVZFTlRTIHdhcyB0byByZWR1
Y2UgZmx1c2hfd29yayBieQ0KcmVkdWNpbmcgbnJfY291bnRlcnMgYW5kIEkgZG9uJ3QgdGhpbmsg
bnJfY291bnRlcnMgc2hvdWxkIGhhdmUgYW4gaW1wYWN0DQpvbiDOlHQuDQoNCj4gYnV0IHRoZSBz
dGF0c191cGRhdGVzIHdhcyBzdGlsbCBzdW0gb2YgYWxsIGV2ZW50cywgc28gdGhlIGZsdXNoIG1p
Z2h0DQo+IGhhdmUgc3RpbGwgdHJpZ2dlcmVkIHRvbyBmcmVxdWVudGx5Lg0KDQo+IE1heWJlIHRo
YXQgd291bGQgYmUgYmV0dGVyIGxvbmctdGVybSBhcHByb2FjaCwgc3BsaXR0aW5nIGludG8gYWNj
dXJhdGUNCj4gYW5kIGFwcHJveGltYXRlIGNvdW50ZXJzIGFuZCByZWZsZWN0IHRoYXQgaW4gdGhl
IGVycm9yIGVzdGltYXRvciAgDQo+IHN0YXRzX3VwZGF0ZXMuDQoNCj4gT3Igc29tZSBvdGhlciBv
cHRpbWl6YXRpb24gb2YgbWVtX2Nncm91cF9jc3NfcnN0YXRfZmx1c2goKS4NCg0KDQpUaGFua3Mg
Zm9yIHlvdXIgaW5zaWdodHMuIFRoaXMgaXMgcmVhbGx5IGF3ZXNvbWUgYW5kIGdvb2QgdG8gZXhw
bG9yZSB0aGUNCmxvbmctdGVybSBhcHByb2FjaC4gRG8geW91IGhhdmUgYW55IHN0cm9uZyBjb25j
ZXJucyB3aXRoIHRoZSBjdXJyZWN0DQpwYXRjaD8gSSB0aGluayB3ZSBzaG91bGQgcHJvY2VlZCB3
aXRoIHRoaXMgYW5kIGZvY3VzIG1vcmUgb24gbG9uZy10ZXJtDQphcHByb2FjaC4NCg0KdGhhbmtz
LA0KU2hha2VlbA0KDQoNCg0K
