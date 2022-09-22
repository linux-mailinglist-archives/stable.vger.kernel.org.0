Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB40E5E68FE
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiIVRBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 13:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIVRBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 13:01:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E97AF6F58;
        Thu, 22 Sep 2022 10:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866109; x=1695402109;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=qCYHm4gaDtc3s29RTgpAEXNzALg1JlVgHM8D+GW9n+4=;
  b=A80rl5jyBCpdeFEHru1PSgwgtAm/AWnzljGGPfYDUi2AUJ/9wO9uiHBK
   qOavy+o0CnVsPXFTATVAmXt+n5RRwc0ltr4sW5uuh+sbEkkPz76ylyV0R
   AjMiVkb2gXQwwXlo6fUBP3PgE87gIipIGhKMNLDvW5d9iIpqDa4Gzpvt5
   0qzcVDNAUJ3Aq2ppcql5PjcwW+OvHvAYjUjo+9GzbWQZYxYahZV1anUKq
   CJbBkLhdGYw5g4l6PNU106RpqzsYomwpF6bFdxMpQlPf3BOzdab5POXde
   42lkFbLp4wkcE8t8UP98oIvxtAML1S6j1QY4tVNBCXHjWAfmlw71nFZxa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="299078222"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208,223";a="299078222"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 10:01:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208,223";a="948675428"
Received: from sponnura-mobl1.amr.corp.intel.com (HELO [10.209.58.200]) ([10.209.58.200])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 10:01:46 -0700
Content-Type: multipart/mixed; boundary="------------3lBZGQfj2C8pWp3quwOFRdc1"
Message-ID: <88c17568-8694-940a-0f1f-9d345e8dcbdb@intel.com>
Date:   Thu, 22 Sep 2022 10:01:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     rafael@kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
        bp@alien8.de, tglx@linutronix.de, andi@lisas.de, puwen@hygon.cn,
        mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
 <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0885eecb-042f-3b74-2965-7d657de59953@amd.com>
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------3lBZGQfj2C8pWp3quwOFRdc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/22/22 09:54, K Prateek Nayak wrote:
> 
> On 9/22/2022 10:14 PM, Dave Hansen wrote:
>> On 9/20/22 23:36, K Prateek Nayak wrote:
>>> Cc: stable@vger.kernel.org
>>> Cc: regressions@lists.linux.dev
>> *Is* this a regression?
> On second thought, it is not a regression.
> Will remove the tag on v2.

What were you planning for v2?

Rafael suggested something like the attached patch.  It's not nearly as
fragile as the Zen check you proposed earlier.

Any testing or corrections on the commentary would be appreciated.
--------------3lBZGQfj2C8pWp3quwOFRdc1
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-ACPI-processor-idle-Limit-Dummy-wait-workaround-to-o.patch"
Content-Disposition: attachment;
 filename*0="0001-ACPI-processor-idle-Limit-Dummy-wait-workaround-to-o.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA1NGU0NjY4MTIyZDQ0N2VlODBlYzQ2NWYyNDRiMTlkOTY4YzRhN2M2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50ZWwu
Y29tPgpEYXRlOiBUaHUsIDIyIFNlcCAyMDIyIDA5OjIyOjI2IC0wNzAwClN1YmplY3Q6IFtQ
QVRDSF0gQUNQSTogcHJvY2Vzc29yIGlkbGU6IExpbWl0ICJEdW1teSB3YWl0IiB3b3JrYXJv
dW5kIHRvIG9sZAogSW50ZWwgc3lzdGVtcwoKT2xkLCBjaXJjYSAyMDAyIGNoaXBzZXRzIGhh
dmUgYSBidWc6IHRoZXkgZG9uJ3QgZ28gaWRsZSB3aGVuIHRoZXkgYXJlCnN1cHBvc2VkIHRv
LiAgU28sIGEgd29ya2Fyb3VuZCB3YXMgYWRkZWQgdG8gc2xvdyB0aGUgQ1BVIGRvd24gYW5k
CmVuc3VyZSB0aGF0IHRoZSBDUFUgd2FpdHMgYSBiaXQgZm9yIHRoZSBjaGlwc2V0IHRvIGFj
dHVhbGx5IGdvIGlkbGUuClRoaXMgd29ya2Fyb3VuZCBpcyBhbmNpZW50IGFuZCBoYXMgYmVl
biBpbiBwbGFjZSBpbiBzb21lIGZvcm0gc2luY2UKdGhlIG9yaWdpbmFsIGtlcm5lbCBBQ1BJ
IGltcGxlbWVudGF0aW9uLgoKQnV0LCB0aGlzIHdvcmthcm91bmQgaXMgdmVyeSBwYWluZnVs
IG9uIG1vZGVybiBzeXN0ZW1zLiAgVGhlICJpbmIoKSIKY2FuIHRha2UgdGhvdXNhbmRzIG9m
IGN5Y2xlcyAoc2VlIExpbms6IGZvciBzb21lIG1vcmUgZGV0YWlsZWQKYXJjaGFlb2xvZ3kp
LgoKRmlyc3QgYW5kIGZvcmVtb3N0LCBtb2Rlcm4gc3lzdGVtcyBzaG91bGQgbm90IGJlIHVz
aW5nIHRoaXMgY29kZS4KVHlwaWNhbCBJbnRlbCBzeXN0ZW1zIGhhdmUgbm90IHVzZWQgaXQg
aW4gb3ZlciBhIGRlY2FkZSBiZWNhdXNlIGl0CmlzIGhvcnJpYmx5IGluZmVyaW9yIHRvIE1X
QUlULWJhc2VkIGlkbGUuCgpEZXNwaXRlIHRoaXMsIHBlb3BsZSBkbyBzZWVtIHRvIGJlIHRy
aXBwaW5nIG92ZXIgdGhpcyB3b3JrYXJvdW5kIG9uCkFNRCBDUFVzIHRvZGF5LgoKTGltaXQg
dGhlICJkdW1teSB3YWl0IiB3b3JrYXJvdW5kIHRvIEludGVsIHN5c3RlbXMuICBTaW5jZSB0
aGlzCmNvZGUgaXMgb25seSB1c2VkIG9uIGFuY2llbnQgSW50ZWwgc3lzdGVtcywgdGhpcyBm
aXggc2hvdWxkIHJlbmRlciBpdApoYXJtbGVzcyBldmVyeXdoZXJlIGVsc2UsIGluY2x1ZGlu
ZyB0aGUgbW9kZXJuIEFNRCBvbmVzLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBIYW5zZW4gPGRh
dmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbT4KQ2M6IExlbiBCcm93biA8bGVuYkBrZXJuZWwu
b3JnPgpTdWdnZXN0ZWQtYnk6IFJhZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tp
QGludGVsLmNvbT4KUmVwb3J0ZWQtYnk6IEsgUHJhdGVlayBOYXlhayA8a3ByYXRlZWsubmF5
YWtAYW1kLmNvbT4KTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIwOTIx
MDYzNjM4LjI0ODktMS1rcHJhdGVlay5uYXlha0BhbWQuY29tLwotLS0KIGRyaXZlcnMvYWNw
aS9wcm9jZXNzb3JfaWRsZS5jIHwgMjMgKysrKysrKysrKysrKysrKysrKystLS0KIDEgZmls
ZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfaWRsZS5jIGIvZHJpdmVycy9hY3BpL3Byb2Nl
c3Nvcl9pZGxlLmMKaW5kZXggMTZhMTY2M2QwMmQ0Li45ZjQwOTE3YzQ5ZWYgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfaWRsZS5jCisrKyBiL2RyaXZlcnMvYWNwaS9w
cm9jZXNzb3JfaWRsZS5jCkBAIC01MzEsMTAgKzUzMSwyNyBAQCBzdGF0aWMgdm9pZCB3YWl0
X2Zvcl9mcmVlemUodm9pZCkKIAkvKiBObyBkZWxheSBpcyBuZWVkZWQgaWYgd2UgYXJlIGlu
IGd1ZXN0ICovCiAJaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9IWVBFUlZJU09SKSkK
IAkJcmV0dXJuOworCS8qCisJICogTW9kZXJuICg+PU5laGFsZW0pIEludGVsIHN5c3RlbXMg
dXNlIEFDUEkgdmlhIGludGVsX2lkbGUsCisJICogbm90IHRoaXMgY29kZS4gIEFzc3VtZSB0
aGF0IGFueSBJbnRlbCBzeXN0ZW1zIHVzaW5nIHRoaXMKKwkgKiBhcmUgYW5jaWVudCBhbmQg
bWF5IG5lZWQgdGhlIGR1bW15IHdhaXQuICBUaGlzIGFsc28gYXNzdW1lcworCSAqIHRoYXQg
dGhlIG1vdGl2YXRpbmcgY2hpcHNldCBpc3N1ZSB3YXMgSW50ZWwtb25seS4KKwkgKi8KKwlp
ZiAoYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yICE9IFg4Nl9WRU5ET1JfSU5URUwpCisJCXJl
dHVybjsKICNlbmRpZgotCS8qIER1bW15IHdhaXQgb3AgLSBtdXN0IGRvIHNvbWV0aGluZyB1
c2VsZXNzIGFmdGVyIFBfTFZMMiByZWFkCi0JICAgYmVjYXVzZSBjaGlwc2V0cyBjYW5ub3Qg
Z3VhcmFudGVlIHRoYXQgU1RQQ0xLIyBzaWduYWwKLQkgICBnZXRzIGFzc2VydGVkIGluIHRp
bWUgdG8gZnJlZXplIGV4ZWN1dGlvbiBwcm9wZXJseS4gKi8KKwkvKgorCSAqIER1bW15IHdh
aXQgb3AgLSBtdXN0IGRvIHNvbWV0aGluZyB1c2VsZXNzIGFmdGVyIFBfTFZMMiByZWFkCisJ
ICogYmVjYXVzZSBjaGlwc2V0cyBjYW5ub3QgZ3VhcmFudGVlIHRoYXQgU1RQQ0xLIyBzaWdu
YWwgZ2V0cworCSAqIGFzc2VydGVkIGluIHRpbWUgdG8gZnJlZXplIGV4ZWN1dGlvbiBwcm9w
ZXJseQorCSAqCisJICogVGhpcyB3b3JrYXJvdW5kIGhhcyBiZWVuIGluIHBsYWNlIHNpbmNl
IHRoZSBvcmlnaW5hbCBBQ1BJCisJICogaW1wbGVtZW50YXRpb24gd2FzIG1lcmdlZCwgY2ly
Y2EgMjAwMi4KKwkgKgorCSAqIElmIGEgcHJvZmlsZSBpcyBwb2ludGluZyB0byB0aGlzIGlu
c3RydWN0aW9uLCBwbGVhc2UgZmlyc3QKKwkgKiBjb25zaWRlciBtb3ZpbmcgeW91ciBzeXN0
ZW0gdG8gYSBtb3JlIG1vZGVybiBpZGxlCisJICogbWVjaGFuaXNtLgorCSAqLwogCWlubChh
Y3BpX2dibF9GQURULnhwbV90aW1lcl9ibG9jay5hZGRyZXNzKTsKIH0KIAotLSAKMi4yNS4x
Cgo=

--------------3lBZGQfj2C8pWp3quwOFRdc1--
