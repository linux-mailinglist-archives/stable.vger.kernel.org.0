Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB07114928
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 23:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfLEWXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 17:23:48 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43483 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEWXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 17:23:47 -0500
Received: by mail-qt1-f194.google.com with SMTP id q8so5110509qtr.10
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 14:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=s9HuZFqazi071tR46CJtidfMMQKEUIWC1jwTBGYP1+w=;
        b=cZ6NlkcxxGeMFCfa3hNffYbt0adwBZu56/wsfc7GzrfjY7exDtzAzT69JkqoOcFpm8
         f/DyD28W+DSoWxWBnipzKKfbHXYFVd1KXHBALe7U92Rlb0TUsWCVWecCbyZNfsdy5b+Q
         umBbiwYYXAJFbsr4PPSFRGm5XP7lnsOzGREK8bLhFcBl19HybxYqB34HQGQBygroaZYe
         KTHKnPrku21QGMQky2zEVpbt8qArb3r30PwDE6ztueSyGlJ4chmylOb3WfxksBOp/SdP
         88RI15LyNSV036ykGPGm2olovdquCBRFsjwq8Y8+9XHkNtSjyAb5qjPcekWz2+rrhUQ+
         omuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=s9HuZFqazi071tR46CJtidfMMQKEUIWC1jwTBGYP1+w=;
        b=ZEu6Br7BDhfR92/gpIc53Qdb5Y4qE0yxoR3PlQvQYOt4U1BNcnvjJ3s28Fuy5EOvpI
         RZwvWduFdp2gQ0hoLboR+PHeFIuGDqEmrXzEVfMSUMMfKKhBx9NZDCOBPtmMzwPwS2f+
         7lplDZBwJ8evsN0rZj7D6YcF7zHaCl2Raq8UzdYSSf8EfrjoDR1rGf/4zfR+6lfGPsED
         +iHrDt9GTHexfZpGoTxPH94LL2dN7dblivM9q8IihdgLvR7HfsxVFFpGTF9mLzaFzdn8
         pbSuVMklqCKZwQgbDbp7K5FTGl9ArexzJfyXOjhDDJArPT1EDFppqEpih5FBIm0oohT5
         DImg==
X-Gm-Message-State: APjAAAWAEyBRn8jIxhIuoV6nBN1VBO+OH2n9cf8I6hkpCwTVgJFn56YE
        cWF/KLC6Ow8VKay+P329N1bQO9UL9d0=
X-Google-Smtp-Source: APXvYqx7GJ9s3s0mo7mEDapHflc+9TKM5IVSvrVc5pjmpmXIK6z7WiQr0sZpTn3eRDhYfRmpclVinA==
X-Received: by 2002:ac8:43d0:: with SMTP id w16mr10371261qtn.43.1575584626599;
        Thu, 05 Dec 2019 14:23:46 -0800 (PST)
Received: from ?IPv6:2600:1000:b06e:b1cc:9498:2fee:3c1:2a4? ([2600:1000:b06e:b1cc:9498:2fee:3c1:2a4])
        by smtp.gmail.com with ESMTPSA id k62sm3911034qkc.95.2019.12.05.14.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 14:23:46 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 17:23:44 -0500
Message-Id: <D04891DC-0EE8-4EA0-8541-97E4AB4DED3C@lca.pw>
References: <ff202f9f-4124-7e63-a5fb-ebeb2a263632@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <ff202f9f-4124-7e63-a5fb-ebeb2a263632@linux.alibaba.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 5, 2019, at 5:09 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>=20
> As I said the status return value issue is a regression, but the -ENOENT i=
ssue has been there since the syscall was introduced (The visual inspection s=
hows so I didn't actually run test against 2.6.x kernel, but it returns 0 fo=
r >=3D 3.10 at least). It does need further clarification (doc problem or co=
de problem).

The question is why we should care about this change of behavior. It is argu=
ably you are even trying to fix an ambiguous part of the manpage, but instea=
d leave a more obviously one still broken. It is really difficult to underst=
and the logical here.

>=20
> Michal also noticed several inconsistencies when he was reworking move_pag=
es(), and I agree with him that we'd better not touch them without a clear u=
secase.

It could argue that there is no use case to restore the behavior either.


