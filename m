Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A601510FDF
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 06:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357624AbiD0EXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 00:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiD0EXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 00:23:03 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D3115377E;
        Tue, 26 Apr 2022 21:19:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id bg25so424560wmb.4;
        Tue, 26 Apr 2022 21:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=0l8iGzLC+8Iysz4+NCCVWeC/6mq/EOtsI3Hk6PUgHpM=;
        b=o/uvS1gPGDfuiug23IEXyICjRpiEgxXu33dLFg0eUyWHFzXFPGIgN3DOrpmetZrdiH
         zYOiBmgnr/mxSgUMiBPFzJVI9nlouT74saccvgVbMEKhrSVo2JejDiDm8DJIRHVsJruE
         6rpTa9A+o+zfB+NJ9ZI+ObSklGgaRvjaIL0W195O+8ci7MJCAu0PuI9jfM0iethzWVwt
         6wkFVmfSO7cp/ueoT0ZPD3dzP21sTksRJBJ0AxZytdgjf/8ZUcrg2TOjntWe1h20D9n+
         wVCnGp7czdbmqOxfV1px4Lj2VnOHTxInX4RWIOApaVSNYHwBo6sPXA5JZo7FbYgXjKQG
         NbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=0l8iGzLC+8Iysz4+NCCVWeC/6mq/EOtsI3Hk6PUgHpM=;
        b=H820Uvz5b53NopvYzguoDq3pZMkBYJyxPNjedZZJ/mJjMFmRkCNNfzk7KU+AVqP32q
         qxfAtBtB7eADII11U+tqZfsWKU5zK5VXaBwv+QGyerb1M8vfR4OOoHZlyFoyHb+hd3zg
         5rhkqelTscySpb+q8PdvIXd60YhStg6KQ8xgSm/4qCYNFBPpO/Q8B+Y7dduCXs51iHGg
         JJLlidutUGiXuJkpdRBS9OUWQ+Gs/TbQ9TwB9c2Mvhdn9YoykrNRoqfxKYxddbvQnsrk
         Zit0nAYOiW3nmmRiXMDEzYm8amzSnXgRf1oplnhQ2mQzsJvrbhe89/RpqZXAbquPo8nl
         +TSA==
X-Gm-Message-State: AOAM532KhEOXmWn2k3ayeeDsWqPAAlSEBW3MDMpRPxYK1rQBTXgfu3Qe
        vX/BD36LsMqCrY0OKCmELPCDUSMu2PNpCGvj
X-Google-Smtp-Source: ABdhPJx1+9cUHunJZn+UhSUQlhNHdcXkYafXB18PrkREzNQeI+L5n3fCv9DeAg/425mkk6BCV3f61g==
X-Received: by 2002:a1c:f605:0:b0:37b:b5de:89a0 with SMTP id w5-20020a1cf605000000b0037bb5de89a0mr23552615wmc.88.1651033191647;
        Tue, 26 Apr 2022 21:19:51 -0700 (PDT)
Received: from giga-mm.localdomain ([195.245.23.54])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm708987wmq.40.2022.04.26.21.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 21:19:50 -0700 (PDT)
Message-ID: <a752f2d7d45d7f57b14cf45a01e583f9d8da0754.camel@gmail.com>
Subject: Re: [PATCH] ep93xx: clock: Fix UAF in mach-ep93xx/clock.c
From:   Alexander Sverdlin <alexander.sverdlin@gmail.com>
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Wed, 27 Apr 2022 06:19:50 +0200
In-Reply-To: <20220427022111.772457-1-wanjiabing@vivo.com>
References: <20220427022111.772457-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhhbmsgeW91LCBXYW4hCgpPbiBXZWQsIDIwMjItMDQtMjcgYXQgMTA6MjEgKzA4MDAsIFdhbiBK
aWFiaW5nIHdyb3RlOgo+IEZpeCBmb2xsb3dpbmcgY29jY2ljaGVjayBlcnJvcnM6Cj4gLi9hcmNo
L2FybS9tYWNoLWVwOTN4eC9jbG9jay5jOjM1MTo5LTEyOiBFUlJPUjogcmVmZXJlbmNlIHByZWNl
ZGVkIGJ5IGZyZWUgb24gbGluZSAzNDkKPiAuL2FyY2gvYXJtL21hY2gtZXA5M3h4L2Nsb2NrLmM6
NDU4OjktMTI6IEVSUk9SOiByZWZlcmVuY2UgcHJlY2VkZWQgYnkgZnJlZSBvbiBsaW5lIDQ1Ngo+
IAo+IEZpeCB0d28gbW9yZSBwb3RlbnRpYWwgVUFGIGVycm9ycy4KPiAKPiBMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjA0MTgxMjEyMTIuNjM0MjU5MDYxQGxpbnV4Zm91bmRh
dGlvbi5vcmcvCj4gRml4ZXM6IDk2NDVjY2M3YmQ3YSAoImVwOTN4eDogY2xvY2s6IGNvbnZlcnQg
aW4tcGxhY2UgdG8gQ09NTU9OX0NMSyIpCj4gU2lnbmVkLW9mZi1ieTogV2FuIEppYWJpbmcgPHdh
bmppYWJpbmdAdml2by5jb20+CgpBY2tlZC1ieTogQWxleGFuZGVyIFN2ZXJkbGluIDxhbGV4YW5k
ZXIuc3ZlcmRsaW5AZ21haWwuY29tPgoKPiAtLS0KPiDCoGFyY2gvYXJtL21hY2gtZXA5M3h4L2Ns
b2NrLmMgfCA4ICsrKysrKy0tCj4gwqAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLWVwOTN4eC9jbG9j
ay5jIGIvYXJjaC9hcm0vbWFjaC1lcDkzeHgvY2xvY2suYwo+IGluZGV4IDRmYTZlYTU0NjFiNy4u
MzVmMzczNGU1MTJjIDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtL21hY2gtZXA5M3h4L2Nsb2NrLmMK
PiArKysgYi9hcmNoL2FybS9tYWNoLWVwOTN4eC9jbG9jay5jCj4gQEAgLTM0NSw4ICszNDUsMTAg
QEAgc3RhdGljIHN0cnVjdCBjbGtfaHcgKmNsa19od19yZWdpc3Rlcl9kZGl2KGNvbnN0IGNoYXIg
Km5hbWUsCj4gwqDCoMKgwqDCoMKgwqDCoHBzYy0+aHcuaW5pdCA9ICZpbml0Owo+IMKgCj4gwqDC
oMKgwqDCoMKgwqDCoGNsayA9IGNsa19yZWdpc3RlcihOVUxMLCAmcHNjLT5odyk7Cj4gLcKgwqDC
oMKgwqDCoMKgaWYgKElTX0VSUihjbGspKQo+ICvCoMKgwqDCoMKgwqDCoGlmIChJU19FUlIoY2xr
KSkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKga2ZyZWUocHNjKTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIEVSUl9DQVNUKGNsayk7Cj4gK8KgwqDC
oMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAmcHNjLT5odzsKPiDCoH0K
PiBAQCAtNDUyLDggKzQ1NCwxMCBAQCBzdGF0aWMgc3RydWN0IGNsa19odyAqY2xrX2h3X3JlZ2lz
dGVyX2Rpdihjb25zdCBjaGFyICpuYW1lLAo+IMKgwqDCoMKgwqDCoMKgwqBwc2MtPmh3LmluaXQg
PSAmaW5pdDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBjbGsgPSBjbGtfcmVnaXN0ZXIoTlVMTCwg
JnBzYy0+aHcpOwo+IC3CoMKgwqDCoMKgwqDCoGlmIChJU19FUlIoY2xrKSkKPiArwqDCoMKgwqDC
oMKgwqBpZiAoSVNfRVJSKGNsaykpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGtmcmVlKHBzYyk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBFUlJf
Q0FTVChjbGspOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gJnBzYy0+aHc7Cj4gwqB9CgotLSAKQWxleGFuZGVyIFN2ZXJkbGluLgoK

