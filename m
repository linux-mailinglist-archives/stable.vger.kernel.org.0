Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADC5F34FB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJCR4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJCRzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:55:12 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E03F10FE6;
        Mon,  3 Oct 2022 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664819691; x=1696355691;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=uNQsP0QcxaUqiGvM3CPkPfMoDdNhIsBjWiT+0LzlH3o=;
  b=W8mxAtzvHyp7PZIdpiZd2P4wGCgqw29SMU1++t5wSFKI2jQ/fXRDIAlb
   Aoo1JierEfSyIBj+wha25/n3FDse8i63JvhDW0qn4cOZEuvyz7bxq9gHA
   c5og9q1XN0DEA1L3ggV1pejBzP6Lxe567VFAX678th5/aT53RPn1PdsfD
   0=;
X-IronPort-AV: E=Sophos;i="5.93,366,1654560000"; 
   d="scan'208";a="247815422"
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Thread-Topic: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 17:54:49 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 6804E87F61;
        Mon,  3 Oct 2022 17:54:48 +0000 (UTC)
Received: from EX19D012UWC002.ant.amazon.com (10.13.138.165) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 3 Oct 2022 17:54:35 +0000
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX19D012UWC002.ant.amazon.com (10.13.138.165) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Mon, 3 Oct 2022 17:54:35 +0000
Received: from EX19D002UWC004.ant.amazon.com ([fe80::f92f:5ec1:6ed3:7754]) by
 EX19D002UWC004.ant.amazon.com ([fe80::f92f:5ec1:6ed3:7754%4]) with mapi id
 15.02.1118.012; Mon, 3 Oct 2022 17:54:35 +0000
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Bacco, Mike" <mbacco@amazon.com>
Thread-Index: AQHY1EeKPnOMRVz3KU6wb3fLP++ZDK37PzMAgAFFSQA=
Date:   Mon, 3 Oct 2022 17:54:35 +0000
Message-ID: <9BEC548C-6849-483B-9A30-10EFFB145E1C@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
 <YzmujBxtwUxHexem@kroah.com>
In-Reply-To: <YzmujBxtwUxHexem@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.161.69]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B14D7DA93089D4E81E4FA4747E18A46@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTAvMi8yMiwgODozMCBBTSwgIkdyZWcgS0giIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
Zz4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRz
aWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFj
aG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29u
dGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIE9uIFRodSwgU2VwIDI5LCAyMDIyIGF0IDA5OjA2OjQ1
UE0gKzAwMDAsIFJpc2hhYmggQmhhdG5hZ2FyIHdyb3RlOg0KICAgID4gVGhpcyBwYXRjaCBzZXJp
ZXMgYmFja3BvcnRzIGEgYnVuY2ggb2YgcGF0Y2hlcyByZWxhdGVkIElSUSBoYW5kbGluZw0KICAg
ID4gd2l0aCByZXNwZWN0IHRvIGZyZWVpbmcgdGhlIGlycSBsaW5lIHdoaWxlIElSUSBpcyBpbiBm
bGlnaHQgYXQgQ1BVDQogICAgPiBvciBhdCB0aGUgaGFyZHdhcmUgbGV2ZWwuDQogICAgPiBSZWNl
bnRseSB3ZSBzYXcgdGhpcyBpc3N1ZSBpbiBzZXJpYWwgODI1MCBkcml2ZXIgd2hlcmUgdGhlIElS
USB3YXMgYmVpbmcNCiAgICA+IGZyZWVkIHdoaWxlIHRoZSBpcnEgd2FzIGluIGZsaWdodCBvciBu
b3QgeWV0IGRlbGl2ZXJlZCB0byB0aGUgQ1BVLiBBcyBhDQogICAgPiByZXN1bHQgdGhlIGlycWNo
aXAgd2FzIGdvaW5nIGludG8gYSB3ZWRnZWQgc3RhdGUgYW5kIElSUSB3YXMgbm90IGdldHRpbmcN
CiAgICA+IGRlbGl2ZXJlZCB0byB0aGUgY3B1LiBUaGVzZSBwYXRjaGVzIGhlbHBlZCBmaXhlZCB0
aGUgaXNzdWUgaW4gNC4xNA0KICAgID4ga2VybmVsLg0KDQogICAgV2h5IGlzIHRoZSBzZXJpYWwg
ZHJpdmVyIGZyZWVpbmcgYW4gaXJxIHdoaWxlIHRoZSBzeXN0ZW0gaXMgcnVubmluZz8NCiAgICBB
aCwgdGhpcyBjb3VsZCBoYXBwZW4gb24gYSB0dHkgaGFuZ3VwLCByaWdodD8NClllcywgZXhhY3Rs
eSBkdXJpbmcgdHR5IGhhbmd1cCB3ZSBzZWUgdGhpcyBzZXF1ZW5jZSBoYXBwZW5pbmcuDQpJdCBk
b2Vzbid0IGhhcHBlbiBvbiBldmVyeSBoYW5ndXAgYnV0IGNhbiBiZSByZXByb2R1Y2VkIHdpdGhp
biAxMCB0cmllcy4gV2UgZGlkbid0IHNlZSB0aGUgc2FtZQ0KYmVoYXZpb3IgaW4gNS4xMCBhbmQg
aGVuY2UgZm91bmQgdGhlc2UgY29tbWl0cy4NCg0KICAgID4gTGV0IHVzIGtub3cgaWYgbW9yZSBw
YXRjaGVzIG5lZWQgYmFja3BvcnRpbmcuDQoNCiAgICBXaGF0IGhhcmR3YXJlIHBsYXRmb3JtIHdl
cmUgdGhlc2UgcGF0Y2hlcyB0ZXN0ZWQgb24gdG8gdmVyaWZ5IHRoZXkgd29yaw0KICAgIHByb3Bl
cmx5PyAgQW5kIHdoeSBjYW4ndCB0aGV5IG1vdmUgdG8gNC4xOSBvciBuZXdlciBpZiB0aGV5IHJl
YWxseSBuZWVkDQogICAgdGhpcyBmaXg/ICBXaGF0J3MgcHJldmVudGluZyB0aGF0Pw0KDQogICAg
QXMgQW1hem9uIGRvZXNuJ3Qgc2VlbSB0byBiZSB0ZXN0aW5nIDQuMTQueSAtcmMgcmVsZWFzZXMs
IEkgZmluZCBpdCBvZGQNCiAgICB0aGF0IHlvdSBhbGwgZGlkIHRoaXMgYmFja3BvcnQuICBJcyB0
aGlzIGEga2VybmVsIHRoYXQgeW91IGFsbCBjYXJlDQogICAgYWJvdXQ/DQoNClRoZXNlIHdlcmUg
dGVzdGVkIG9uIEludGVsIHg4Nl82NCAoWGVvbiBQbGF0aW51bSA4MjU5KS4NCkFtYXpvbiBsaW51
eCAyIHN0aWxsIHN1cHBvcnRzIDQuMTQga2VybmVsIGZvciBvdXIgY3VzdG9tZXJzLCBzbyB3ZSB3
b3VsZCBuZWVkIHRvIGZpeCB0aGF0Lg0KDQogICAgdGhhbmtzLA0KDQogICAgZ3JlZyBrLWgNCg0K
