Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826171146A4
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 19:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfLESLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 13:11:55 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39161 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbfLESLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 13:11:55 -0500
Received: by mail-qt1-f196.google.com with SMTP id g1so4402066qtj.6
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 10:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=giazvTsGDVrAkD0F11ztp2e1h3nTDeaUJG0efXt9Qrs=;
        b=lFMXFtEcWUl3vJMrunz+yvhUAHmdxhRsKYC0p7Ww0hm9AofnOkELBIELu3Y54o+WBW
         novXm1JEjC85nkqN6PL53QjDNkdrPwCN36KDxMm+6zGCn8/oq0+btL8PR972iASQLSq2
         OSIUYWIvaSUXx5OcYje2nqq6KTSyBnjhr+jeeXyzkwNzIjgUpYOhR5OUvIPgj8xhODnd
         ih1iXWDSE7ssl9uKceGzrbcY5aEwHaVd2j5OfgxkzP+6qS1Jq8uXjdH9W471R/yLTybl
         UXlPvsTwbuFRbCoH7k3IiOR/tBOzGBCW9oSHaukPeSItSueq3tqES/4Jx+Au4j+MBIzX
         ykxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=giazvTsGDVrAkD0F11ztp2e1h3nTDeaUJG0efXt9Qrs=;
        b=Vixtox6iZYiysSxhMFPIMttm/vrgo3bw2ARxd5yU6SPeyf/7Kj/Vhm/IbhzwWOho2E
         1SgIdiGpnW9kUofOq40UgfIz5ExyagoJmKCLMwUuQVlQRLNYLRhDdz/oGRsPiXojDPpv
         2XWVy6+XGVSJZW/UMmtdcONeZ6bKiHKLP4K7k9j0JQB2Z0NhVve1kTpd74SPWciMMudw
         7+zxzbv35E/73CiGCdVr2tUfr8EtvMIoIK6OaarLQLipWowQlvOfyy5l5eCncN0KgOLB
         evj9V4eYyMEhR5PQs0BrpReP1/xxA59u7M3/oHoURptFPCO3HyTeG0rffKSDqc9bQ12z
         klKA==
X-Gm-Message-State: APjAAAVXmL60rBpkSF59poDsvBWkgf1w6D+dN3eggdmllIjrOy1vrozX
        RWgmPsDh/RazJpruwLJ2I6wC27/d6GXwyw==
X-Google-Smtp-Source: APXvYqyAWzrAYSXDcjIG4gMKpsUjXiPIN5Oj6sKdEq19PPy08baLSSvxwi0IrUd/1m+F1gSsOAOZNQ==
X-Received: by 2002:aed:2805:: with SMTP id r5mr8778816qtd.335.1575569513941;
        Thu, 05 Dec 2019 10:11:53 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id u12sm5589261qta.79.2019.12.05.10.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 10:11:52 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 13:11:51 -0500
Message-Id: <1707CDD0-E05E-411A-A093-35E8E50ACA4B@lca.pw>
References: <a16b53f9-92c9-ff01-06c1-530647ecaff1@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <a16b53f9-92c9-ff01-06c1-530647ecaff1@linux.alibaba.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 5, 2019, at 12:39 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>=20
> There are definitely a few inconsistencies, but I think the manpage is qui=
te clear for this specific case, which says "status is an array of integers t=
hat return the status of each page. The array contains valid values only if m=
ove_pages() did not return an error." And, it looks kernel just misbehaved s=
ince 4.17 due to the fixes commit, so it sounds like a regression too.

=E2=80=9COnly if=E2=80=9D  in strictly logical term does not necessarily mea=
n it must contain valid values if move_pages() succeed.=
