Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16866E7A92
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjDSNXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjDSNXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:23:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AF21544C;
        Wed, 19 Apr 2023 06:22:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1525B1FD8C;
        Wed, 19 Apr 2023 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681910572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ytt54amvc+2eVsRCq2ihaV92ZWWdK0L5K4kWIpvdk0w=;
        b=j5Qda5gTpuRF4NmLA6bc7MGos4y7xUHHTTVkMZ9Bj0JillDpQqIMZuw2YGHkEwdQGAgj63
        ldx7MWfQN5JIg//NSGPF8Lubye+qVwr0TrYh/dNdZ+K4F9Sz+OvMzp/BTgcfUyUeJsKOxw
        7tvvzqCM1fYrKBhD/zCmr5pr8J4RMC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681910572;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ytt54amvc+2eVsRCq2ihaV92ZWWdK0L5K4kWIpvdk0w=;
        b=tye3j6YwboKqxcW+3ScWE/gnM3mY0qMEluSZH0WnCpjSQIJUk3zvPKLxI8lBFTRnLlt4W+
        4GNSxCK0W+0MUWCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F1091390E;
        Wed, 19 Apr 2023 13:22:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sjLPHyvrP2QUKAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 19 Apr 2023 13:22:51 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 64a6da71;
        Wed, 19 Apr 2023 13:22:50 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] ceph: fix potential use-after-free bug when trimming
 caps
References: <20230418014506.95428-1-xiubli@redhat.com>
        <877cu9w9ti.fsf@brahms.olymp>
        <008bc17d-d5fb-107e-4405-ebacc1568890@redhat.com>
Date:   Wed, 19 Apr 2023 14:22:50 +0100
In-Reply-To: <008bc17d-d5fb-107e-4405-ebacc1568890@redhat.com> (Xiubo Li's
        message of "Wed, 19 Apr 2023 10:28:11 +0800")
Message-ID: <87r0sgt39x.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

WGl1Ym8gTGkgPHhpdWJsaUByZWRoYXQuY29tPiB3cml0ZXM6DQoNCj4gT24gNC8xOC8yMyAyMjoy
MCwgTHXDrXMgSGVucmlxdWVzIHdyb3RlOg0KPj4geGl1YmxpQHJlZGhhdC5jb20gd3JpdGVzOg0K
Pj4NCj4+PiBGcm9tOiBYaXVibyBMaSA8eGl1YmxpQHJlZGhhdC5jb20+DQo+Pj4NCj4+PiBXaGVu
IHRyaW1taW5nIHRoZSBjYXBzIGFuZCBqdXN0IGFmdGVyIHRoZSAnc2Vzc2lvbi0+c19jYXBfbG9j
aycgaXMNCj4+PiByZWxlYXNlZCBpbiBjZXBoX2l0ZXJhdGVfc2Vzc2lvbl9jYXBzKCkgdGhlIGNh
cCBtYXliZSByZW1vdmVkIGJ5DQo+Pj4gYW5vdGhlciB0aHJlYWQsIGFuZCB3aGVuIHVzaW5nIHRo
ZSBzdGFsZSBjYXAgbWVtb3J5IGluIHRoZSBjYWxsYmFja3MNCj4+PiBpdCB3aWxsIHRyaWdnZXIg
dXNlLWFmdGVyLWZyZWUgY3Jhc2guDQo+Pj4NCj4+PiBXZSBuZWVkIHRvIGNoZWNrIHRoZSBleGlz
dGVuY2Ugb2YgdGhlIGNhcCBqdXN0IGFmdGVyIHRoZSAnY2ktPmlfY2VwaF9sb2NrJw0KPj4+IGJl
aW5nIGFjcXVpcmVkLiBBbmQgZG8gbm90aGluZyBpZiBpdCdzIGFscmVhZHkgcmVtb3ZlZC4NCj4+
IFlvdXIgcGF0Y2ggc2VlbXMgdG8gYmUgT0ssIGJ1dCBJJ2xsIGJlIGhvbmVzdDogdGhlIGxvY2tp
bmcgaXMgKnNvKiBjb21wbGV4DQo+PiB0aGF0IEkgY2FuIHNheSBmb3Igc3VyZSBpdCByZWFsbHkg
c29sdmVzIGFueSBwcm9ibGVtIDotKA0KPj4NCj4+IGNlcGhfcHV0X2NhcCgpIHVzZXMgbWRzYy0+
Y2Fwc19saXN0X2xvY2sgdG8gcHJvdGVjdCB0aGUgbGlzdCwgYnV0IEkgY2FuJ3QNCj4+IGJlIHN1
cmUgdGhhdCBob2xkaW5nIGNpLT5pX2NlcGhfbG9jayB3aWxsIHByb3RlY3QgYSByYWNlIGluIHRo
ZSBjYXNlDQo+PiB5b3UncmUgdHJ5aW5nIHRvIHNvbHZlLg0KPg0KPiBUaGUgJ21kc2MtPmNhcHNf
bGlzdF9sb2NrJyB3aWxsIHByb3RlY3QgdGhlIG1lbWJlcnMgaW4gbWRzYzoNCj4NCj4gwqDCoMKg
wqDCoMKgwqAgLyoNCj4gwqDCoMKgwqDCoMKgwqDCoCAqIENhcCByZXNlcnZhdGlvbnMNCj4gwqDC
oMKgwqDCoMKgwqDCoCAqDQo+IMKgwqDCoMKgwqDCoMKgwqAgKiBNYWludGFpbiBhIGdsb2JhbCBw
b29sIG9mIHByZWFsbG9jYXRlZCBzdHJ1Y3QgY2VwaF9jYXBzLCByZWZlcmVuY2VkDQo+IMKgwqDC
oMKgwqDCoMKgwqAgKiBieSBzdHJ1Y3QgY2VwaF9jYXBzX3Jlc2VydmF0aW9ucy7CoCBUaGlzIGVu
c3VyZXMgdGhhdCB3ZSBwcmVhbGxvY2F0ZQ0KPiDCoMKgwqDCoMKgwqDCoMKgICogbWVtb3J5IG5l
ZWRlZCB0byBzdWNjZXNzZnVsbHkgcHJvY2VzcyBhbiBNRFMgcmVzcG9uc2UuIChJZiBhbiBNRFMN
Cj4gwqDCoMKgwqDCoMKgwqDCoCAqIHNlbmRzIHVzIGNhcCBpbmZvcm1hdGlvbiBhbmQgd2UgZmFp
bCB0byBwcm9jZXNzIGl0LCB3ZSB3aWxsIGhhdmUNCj4gwqDCoMKgwqDCoMKgwqDCoCAqIHByb2Js
ZW1zIGR1ZSB0byB0aGUgY2xpZW50IGFuZCBNRFMgYmVpbmcgb3V0IG9mIHN5bmMuKQ0KPiDCoMKg
wqDCoMKgwqDCoMKgICoNCj4gwqDCoMKgwqDCoMKgwqDCoCAqIFJlc2VydmF0aW9ucyBhcmUgJ293
bmVkJyBieSBhIGNlcGhfY2FwX3Jlc2VydmF0aW9uIGNvbnRleHQuDQo+IMKgwqDCoMKgwqDCoMKg
wqAgKi8NCj4gwqDCoMKgwqDCoMKgwqAgc3BpbmxvY2tfdMKgwqDCoMKgwqAgY2Fwc19saXN0X2xv
Y2s7DQo+IMKgwqDCoMKgwqDCoMKgIHN0cnVjdMKgwqDCoMKgwqDCoMKgwqDCoCBsaXN0X2hlYWQg
Y2Fwc19saXN0OyAvKiB1bnVzZWQgKHJlc2VydmVkIG9yDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgdW5yZXNlcnZlZCkgKi8NCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0
wqDCoMKgwqDCoMKgwqDCoMKgIGxpc3RfaGVhZCBjYXBfd2FpdF9saXN0Ow0KPiDCoMKgwqDCoMKg
wqDCoCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2Fwc190b3RhbF9jb3VudDvCoMKgwqAg
LyogdG90YWwgY2FwcyBhbGxvY2F0ZWQgKi8NCj4gwqDCoMKgwqDCoMKgwqAgaW50wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNhcHNfdXNlX2NvdW50O8KgwqDCoMKgwqAgLyogaW4gdXNlICovDQo+
IMKgwqDCoMKgwqDCoMKgIGludMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjYXBzX3VzZV9tYXg7
wqDCoMKgwqDCoMKgwqAgLyogbWF4IHVzZWQgY2FwcyAqLw0KPiDCoMKgwqDCoMKgwqDCoCBpbnTC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2Fwc19yZXNlcnZlX2NvdW50O8KgIC8qIHVudXNlZCwg
cmVzZXJ2ZWQgKi8NCj4gwqDCoMKgwqDCoMKgwqAgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGNhcHNfYXZhaWxfY291bnQ7wqDCoMKgIC8qIHVudXNlZCwgdW5yZXNlcnZlZCAqLw0KPiDCoMKg
wqDCoMKgwqDCoCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2Fwc19taW5fY291bnQ7wqDC
oMKgwqDCoCAvKiBrZWVwIGF0IGxlYXN0IHRoaXMgbWFueQ0KPg0KPiBOb3QgcHJvdGVjdGluZyB0
aGUgY2FwIGxpc3QgaW4gc2Vzc2lvbiBvciBpbm9kZS4NCj4NCj4NCj4gQW5kIHRoZSByYWN5IGlz
IGJldHdlZW4gdGhlIHNlc3Npb24ncyBjYXAgbGlzdCBhbmQgaW5vZGUncyBjYXAgcmJ0cmVlIGFu
ZCBib3RoDQo+IGFyZSBob2xkaW5nIHRoZSBzYW1lICdjYXAnIHJlZmVyZW5jZS4NCj4NCj4gU28g
aW4gJ2NlcGhfaXRlcmF0ZV9zZXNzaW9uX2NhcHMoKScgYWZ0ZXIgZ2V0dGluZyB0aGUgJ2NhcCcg
YW5kIHJlbGVhc2luZyB0aGUNCj4gJ3Nlc3Npb24tPnNfY2FwX2xvY2snLCBqdXN0IGJlZm9yZSBw
YXNzaW5nIHRoZSAnY2FwJyB0byBfY2IoKSBhbm90aGVyIHRocmVhZA0KPiBjb3VsZCBjb250aW51
ZSBhbmQgcmVsZWFzZSB0aGUgJ2NhcCcuIFRoZW4gdGhlICdjYXAnIHNob3VsZCBiZSBzdGFsZSBu
b3cgYW5kDQo+IGFmdGVyIGJlaW5nIHBhc3NlZCB0byBfY2IoKSB0aGUgJ2NhcCcgd2hlbiBkZXJl
ZmVyZW5jaW5nIGl0IHdpbGwgY3Jhc2ggdGhlDQo+IGtlcm5lbC4NCj4NCj4gQW5kIGlmIHRoZSAn
Y2FwJyBpcyBzdGFsZSwgaXQgc2hvdWxkbid0IGV4aXN0IGluIHRoZSBpbm9kZSdzIGNhcCByYnRy
ZWUuIFBsZWFzZQ0KPiBub3RlIHRoZSBsb2NrIG9yZGVyIHdpbGwgYmU6DQo+DQo+IDEsIHNwaW5f
bG9jaygmY2ktPmlfY2VwaF9sb2NrKQ0KPg0KPiAyLCBzcGluX2xvY2soJnNlc3Npb24tPnNfY2Fw
X2xvY2spDQo+DQo+DQo+IEJlZm9yZToNCj4NCj4gVGhyZWFkQTogVGhyZWFkQjoNCj4NCj4gX19j
ZXBoX3JlbW92ZV9jYXBzKCkgLS0+DQo+DQo+IMKgwqDCoCBzcGluX2xvY2soJmNpLT5pX2NlcGhf
bG9jaykNCj4NCj4gwqDCoMKgIGNlcGhfcmVtb3ZlX2NhcCgpIC0tPiBjZXBoX2l0ZXJhdGVfc2Vz
c2lvbl9jYXBzKCkgLS0+DQo+DQo+IMKgwqDCoMKgwqDCoMKgIF9fY2VwaF9yZW1vdmVfY2FwKCkg
LS0+IHNwaW5fbG9jaygmc2Vzc2lvbi0+c19jYXBfbG9jayk7DQo+DQo+IGNhcCA9IGxpc3RfZW50
cnkocCwgc3RydWN0IGNlcGhfY2FwLCBzZXNzaW9uX2NhcHMpOw0KPg0KPiBzcGluX3VubG9jaygm
c2Vzc2lvbi0+c19jYXBfbG9jayk7DQo+DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl9s
b2NrKCZzZXNzaW9uLT5zX2NhcF9sb2NrKTsNCj4NCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAv
LyByZW1vdmUgaXQgZnJvbSB0aGUgc2Vzc2lvbidzIGNhcCBsaXN0DQo+DQo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgbGlzdF9kZWxfaW5pdCgmY2FwLT5zZXNzaW9uX2NhcHMpOw0KPg0KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrKCZzZXNzaW9uLT5zX2NhcF9sb2NrKTsNCj4N
Cj4gwqAgwqAgwqAgwqAgwqAgwqAgY2VwaF9wdXRfY2FwKCkNCj4NCj4gdHJpbV9jYXBzX2NiKCdj
YXAnKSAtLT7CoMKgIC8vIHRoZSBfY2IoKSBjb3VsZCBiZSBkZWZlcnJlZCBhZnRlciBUaHJlYWRB
IGZpbmlzaGVkDQo+ICdjZXBoX3B1dF9jYXAoKScNCj4NCj4gc3Bpbl91bmxvY2soJmNpLT5pX2Nl
cGhfbG9jaykgZHJlZmVyZW5jZSBjYXAtPnh4eCB3aWxsIHRyaWdnZXIgY3Jhc2gNCj4NCj4NCj4N
Cj4gV2l0aCB0aGlzIHBhdGNoOg0KPg0KPiBUaHJlYWRBOiBUaHJlYWRCOg0KPg0KPiBfX2NlcGhf
cmVtb3ZlX2NhcHMoKSAtLT4NCj4NCj4gwqDCoMKgIHNwaW5fbG9jaygmY2ktPmlfY2VwaF9sb2Nr
KQ0KPg0KPiDCoMKgwqAgY2VwaF9yZW1vdmVfY2FwKCkgLS0+IGNlcGhfaXRlcmF0ZV9zZXNzaW9u
X2NhcHMoKSAtLT4NCj4NCj4gwqDCoMKgwqDCoMKgwqAgX19jZXBoX3JlbW92ZV9jYXAoKSAtLT4g
c3Bpbl9sb2NrKCZzZXNzaW9uLT5zX2NhcF9sb2NrKTsNCj4NCj4gY2FwID0gbGlzdF9lbnRyeShw
LCBzdHJ1Y3QgY2VwaF9jYXAsIHNlc3Npb25fY2Fwcyk7DQo+DQo+IGNpX25vZGUgPSAmY2FwLT5j
aV9ub2RlOw0KPg0KPiBzcGluX3VubG9jaygmc2Vzc2lvbi0+c19jYXBfbG9jayk7DQo+DQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZzZXNzaW9uLT5zX2NhcF9sb2NrKTsNCj4N
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvLyByZW1vdmUgaXQgZnJvbSB0aGUgc2Vzc2lvbidz
IGNhcCBsaXN0DQo+DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGlzdF9kZWxfaW5pdCgmY2Fw
LT5zZXNzaW9uX2NhcHMpOw0KPg0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2Nr
KCZzZXNzaW9uLT5zX2NhcF9sb2NrKTsNCj4NCj4gwqAgwqAgwqAgwqAgwqAgwqAgY2VwaF9wdXRf
Y2FwKCkNCj4NCj4gdHJpbV9jYXBzX2NiKCdjaV9ub2RlJykgLS0+DQo+DQo+IHNwaW5fdW5sb2Nr
KCZjaS0+aV9jZXBoX2xvY2spDQo+DQo+IHNwaW5fbG9jaygmY2ktPmlfY2VwaF9sb2NrKQ0KPg0K
PiBjYXAgPSByYl9lbnRyeShjaV9ub2RlLCBzdHJ1Y3QgY2VwaF9jYXAsIGNpX25vZGUpO8KgwqDC
oCAvLyBUaGlzIGlzIGJ1Z2d5IGluIHRoaXMNCj4gdmVyc2lvbiwgd2Ugc2hvdWxkIHVzZSB0aGUg
J21kcycgaW5zdGVhZCBhbmQgSSB3aWxsIGZpeCBpdC4NCj4NCj4gaWYgKCFjYXApwqAgeyByZWxl
YXNlIHRoZSBzcGluIGxvY2sgYW5kIHJldHVybiBkaXJlY3RseSB9DQo+DQo+IHNwaW5fdW5sb2Nr
KCZjaS0+aV9jZXBoX2xvY2spDQoNClRoYW5rcyBhIGxvdCBmb3IgdGFraW5nIHRoZSB0aW1lIHRv
IGV4cGxhaW4gYWxsIG9mIHRoaXMuICBNdWNoDQphcHByZWNpYXRlZC4gIEl0IGFsbCBzZWVtcyB0
byBtYWtlIHNlbnNlLCBhbmQsIGFnYWluLCBJIGRvbid0IGhhdmUgYW55DQpyZWFsIG9iamVjdGlv
biB0byB5b3VyIHBhdGNoLiAgSXQncyBqdXN0IHRoYXQgSSBzdGlsbCBmaW5kIHRoZSB3aG9sZQ0K
bG9ja2luZyB0byBiZSB0b28gY29tcGxleCwgYW5kIGV2ZXJ5IGNoYW5nZSB0aGF0IGlzIG1hZGUg
dG8gaXQgbG9va3MgbGlrZQ0Kd2Fsa2luZyBvbiBhIG1pbmUgZmllbGQgOi0pDQoNCj4gV2hpbGUg
d2Ugc2hvdWxkIHN3aXRjaCB0byB1c2UgdGhlICdtZHMnIG9mIHRoZSBjYXAgaW5zdGVhZCBvZiB0
aGUgJ2NpX25vZGUnLA0KPiB3aGljaCBpcyBidWdneS4gSSB3aWxsIGZpeCBpdCBpbiBuZXh0IHZl
cnNpb24uDQoNClllYWgsIEkndmUgdG9vayBhIHF1aWNrIGxvb2sgYXQgdjQgYW5kIGl0IGxvb2tz
IGxpa2UgaXQgZml4ZXMgdGhpcy4NCg0KPj4gSXMgdGhlIGlzc3VlIGluIHRoYXQgYnVnemlsbGEg
cmVwcm9kdWNpYmxlLCBvciB3YXMgdGhhdCBhIG9uZS10aW1lIHRoaW5nPw0KPg0KPiBObywgSSBk
b24ndCB0aGluayBzby4gTG9jYWxseSBJIGhhdmUgdHJpZWQgYnkgdHVybmluZyB0aGUgbWRzIG9w
dGlvbnMgdG8gdHJpZ2dlcg0KPiB0aGUgY2FwIHJlY2xhaW1pbmcgbW9yZSBmcmVxdWVudGx5LCBi
dXQgc3RpbGwgY291bGRuJ3QgcmVwcm9kdWNlIGl0LiBJdCBzaG91bGQNCj4gYmUgdmVyeSBjb3Ju
ZXIgY2FzZS4NCg0KWWVhaCwgdG9vIGJhZC4gIEl0IHdvdWxkIGhlbHAgdG8gZ2FpbiBzb21lIGV4
dHJhIGNvbmZpZGVuY2Ugb24gdGhlIHBhdGNoLg0KDQpDaGVlcnMsDQotLSANCkx1w61zDQo=
