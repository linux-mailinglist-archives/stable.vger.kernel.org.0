Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E734E1EE548
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 15:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgFDN2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 09:28:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:23426 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728119AbgFDN2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 09:28:07 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-67-smgdUXOqPqOLrGJKNE45Cg-1; Thu, 04 Jun 2020 14:28:03 +0100
X-MC-Unique: smgdUXOqPqOLrGJKNE45Cg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 4 Jun 2020 14:28:02 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 4 Jun 2020 14:28:02 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christian Brauner' <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>
CC:     Sargun Dhillon <sargun@sargun.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Robert Sesek <rsesek@google.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Tejun Heo <tj@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Topic: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Index: AQHWOm8IcrQ9iML/NEWzIJOikhNiKKjIcAVA
Date:   Thu, 4 Jun 2020 13:28:02 +0000
Message-ID: <f1b77cafef8c4d159b1daa9cd4a06794@AcuMS.aculab.com>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
In-Reply-To: <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMDQgSnVuZSAyMDIwIDEzOjUyDQouLg0K
PiBGb3Igc2NtIHlvdSBjYW4gZmFpbCBzb21ld2hlcmUgaW4gdGhlIG1pZGRsZSBvZiBwdXR0aW5n
IGFueSBudW1iZXIgb2YNCj4gZmlsZSBkZXNjcmlwdG9ycyBzbyB5b3UncmUgbGVmdCBpbiBhIHN0
YXRlIHdpdGggb25seSBhIHN1YnNldCBvZg0KPiByZXF1ZXN0ZWQgZmlsZSBkZXNjcmlwdG9ycyBp
bnN0YWxsZWQgc28gaXQncyBub3QgcmVhbGx5IHVzZWZ1bCB0aGVyZS4NCj4gQW5kIGlmIHlvdSBt
YW5hZ2UgdG8gaW5zdGFsbCBhbiBmZCBidXQgdGhlbiBmYWlsIHRvIHB1dF91c2VyKCkgaXQNCj4g
dXNlcnNwYWNlIGNhbiBzaW1wbHkgY2hlY2sgaXQncyBmZHMgdmlhIHByb2MgYW5kIGhhcyB0byBh
bnl3YXkgb24gYW55DQo+IHNjbSBtZXNzYWdlIGVycm9yLiBJZiB5b3UgZmFpbCBhbiBzY20gbWVz
c2FnZSB1c2Vyc3BhY2UgYmV0dGVyIGNoZWNrDQo+IHRoZWlyIGZkcy4NCg0KVGhlcmUgaXMgYSBz
aW1pbGFyIGVycm9yIHBhdGggaW4gdGhlIHNjdHAgJ3BlZWxvZmYnIGNvZGUuDQpJZiB0aGUgcHV0
X3VzZXIoKSBmYWlscyBpdCBjdXJyZW50bHkgY2xvc2VzIHRoZSBmZCBiZWZvcmUNCnJldHVybmlu
ZyAtRUZBVUxULg0KDQpJJ20gbm90IGF0IGFsbCBzdXJlIHRoaXMgaXMgaGVscGZ1bC4NClRoZSBh
cHBsaWNhdGlvbiBjYW4ndCB0ZWxsIHdoZXRoZXIgdGhlIFNJR1NFR1YgaGFwcGVuZWQgb24gdGhl
DQpjb3B5aW4gb2YgdGhlIHBhcmFtZXRlcnMgb3IgdGhlIGNvcHlvdXQgb2YgdGhlIHJlc3VsdC4N
Cg0KSVNUTSB0aGF0IGlmIHRoZSBhcHBsaWNhdGlvbiBwYXNzZXMgYW4gYWRkcmVzcyB0aGF0IGNh
bm5vdA0KYmUgd3JpdHRlbiB0byBpdCBkZXNlcnZlcyB3aGF0IGl0IGdldHMgLSB0eXBpY2FsbHkg
YW4gZmQgaXQNCmRvZXNuJ3Qga25vdyB0aGUgbnVtYmVyIG9mLg0KDQpXaGF0IGlzIGltcG9ydGFu
dCBpcyB0aGF0IHRoZSBrZXJuZWwgZGF0YSBpcyBjb25zaXN0ZW50Lg0KU28gd2hlbiB0aGUgcHJv
Y2VzcyBleGl0cyB0aGUgZmQgaXMgY2xvc2VkIGFuZCBhbGwgdGhlIHJlc291cmNlcw0KYXJlIHJl
bGVhc2VkLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

