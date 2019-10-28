Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817CFE6D9A
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 08:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfJ1H4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 03:56:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34577 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733014AbfJ1H4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 03:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572249391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7eZcqHF8b9Ji9D25pn09VHOG3WM+NKx8xJbvY/2TLqA=;
        b=DbyZ1xQIU/cQOKXqY36GKaDvmznKy9CqnikuRE7wX9jOVLqZhYAi6cbeCSOufpoHqhgVim
        GDPbVRO08mf6aaXlJTNLRfAXJN3U+m6avExz5fyBOd4ZtgOpU9VwYD2gPK2yNzCJNYz5Js
        B+MQQEuR/n8IOTUqbl1jkLAChFJrum0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-DBh7Jo9uNF6naolqo2J8-A-1; Mon, 28 Oct 2019 03:56:30 -0400
Received: by mail-wr1-f69.google.com with SMTP id t2so2560079wri.18
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 00:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S5NXpo19hb3uDxW1OhHDcHE5G0aGpOZOkhWsFlEbgJg=;
        b=LtNNMm4NFEIIgAnefZNSyCE9N4U6WKRUAj71qDlw8TZy2eg8aft/ufwS/d5ieRkccA
         7vSp/4ftaWXIQPbgS+4CziIOqWUHktE5hu2IL6y4V2F+XXxglH9W9TZqnc7Z0hJhTIa4
         547YDFjw/R1HKvUIkKFdZWeE1DDF0ZBZxrCjpAnWZEXYxhBYY5iNOTyGNXZl1N888WdP
         ZNVK31Aeiw1Ewd6PB3m4W1JMmpn5yFuh2Qg7Bb2dlMIdh+EjcRdqZtQbKA6jkiNvR7bD
         CpmRVnwddpRGv/k7IBVDqV69PRWraBd3d2n0mnFjx9bt0bej3t9g7cQ5fl+dVP3yRtKO
         XotQ==
X-Gm-Message-State: APjAAAUXhcXWhsePKcCPjPgXSMuf3R32jBVLD832oD72ePy3qkUmWxwb
        WrAxJvYM6VGRw1VC9mrK9dgsdQdjDVCDCfp3RogcrIJUGFLKOIzN8PE4P9uIg1X0MvelhRt7Vuu
        wZ0ycBGItOE1d4MA/
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr13488545wme.99.1572249388646;
        Mon, 28 Oct 2019 00:56:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdujLnbZ/mVVjeXxdogH1Figcm+nBuCvScMbkWCn3k8Tpyjlo4tv3ouf7+I5YMO36ZXlV4Ug==
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr13488519wme.99.1572249388348;
        Mon, 28 Oct 2019 00:56:28 -0700 (PDT)
Received: from [192.168.42.37] (mob-37-176-198-149.net.vodafone.it. [37.176.198.149])
        by smtp.gmail.com with ESMTPSA id v9sm8889789wro.51.2019.10.28.00.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 00:56:27 -0700 (PDT)
Subject: Re: [PATCH] KVM: vmx, svm: always run with EFER.NXE=1 when shadow
 paging is active
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20191027152323.24326-1-pbonzini@redhat.com>
 <20191028065919.AB8C3208C0@mail.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b08a0103-312e-5441-9ffe-33c9df0a9d57@redhat.com>
Date:   Mon, 28 Oct 2019 08:56:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191028065919.AB8C3208C0@mail.kernel.org>
Content-Language: en-US
X-MC-Unique: DBh7Jo9uNF6naolqo2J8-A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/10/19 07:59, Sasha Levin wrote:
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>=20
> The bot has tested the following trees: v5.3.7, v4.19.80, v4.14.150, v4.9=
.197, v4.4.197.
>=20
> v5.3.7: Build OK!
> v4.19.80: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> v4.14.150: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> v4.9.197: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> v4.4.197: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is upstream.
>=20
> How should we proceed with this patch?

It should apply just fine to all branches, just to arch/x86/kvm/vmx.c
instead of arch/x86/kvm/vmx/vmx.c.

Paolo

