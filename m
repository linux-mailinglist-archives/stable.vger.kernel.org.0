Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA8393732
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 22:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhE0Ucw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 16:32:52 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:54120 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbhE0Ucv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 16:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622147478; x=1653683478;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=K6dlUPbkaXkiIQCE8kFQ1SvWc0eC53wXP5Y3FFkH3J0=;
  b=rTv7vlgcAstX+p4gAXWAetPv+ZA1e9VpLFixNkpN9hiatFw/NPS43F/W
   j04xemI2atIyLx2w+4SshmholdzDzkC7t6JscQRPK6WS8hglE0PLMk0gn
   Rqs7TDIZ7iDxCHzCgg6YBvsZD9aSOEZ8YKSxfrsum8cZ/CF5gbq+2bs+g
   4=;
X-IronPort-AV: E=Sophos;i="5.83,228,1616457600"; 
   d="scan'208";a="935425854"
Subject: Re: [PATCH 4.19 00/12] bpf: fix verifier selftests, add CVE-2021-29155 fixes
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 May 2021 20:31:17 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 58613A1D8A;
        Thu, 27 May 2021 20:31:17 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 27 May 2021 20:31:17 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 27 May 2021 20:31:11 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Thu, 27 May 2021 20:31:10
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id A81BD1E; Thu, 27 May 2021 20:31:10 +0000 (UTC)
Date:   Thu, 27 May 2021 20:31:10 +0000
From:   Frank van der Linden <fllinden@amazon.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
CC:     <stable@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <samjonas@amazon.com>
Message-ID: <20210527203109.GA16000@dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com>
References: <20210527173732.20860-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210527173732.20860-1-ovidiu.panait@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 08:37:20PM +0300, Ovidiu Panait wrote:
> This patchset is based on Frank van der Linden's backport of CVE-2021-29155
> fixes to 5.4 and 4.14:
> https://lore.kernel.org/stable/20210429220839.15667-1-fllinden@amazon.com/
> https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/
> 
> With this series, all verifier selftests but one (that has already been
> failing, see [1] for more details) succeed.

Thanks for doing this - when this gets queued up for 4.19, I can then
resubmit my 4.14 series.

Daniel mentioned the CVE-2021-33200 fixes that were just added. If you add
them to this series, I'll add them to the 4.14 series as well. They should
be clean cherry-picks on top of this.

The failing selftest is a little odd - why would it need allowing bounded
loops to succeed if it was written before those were allowed? In any case,
it was already failing, so that shouldn't stop this series from being
applied.

- Frank
