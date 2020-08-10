Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28F324119B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHJUUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:20:17 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:49645 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHJUUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:20:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597090815; x=1628626815;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h9kdTkr7r5p5qeweEdwI4nWekqpSq55vBrQz08aOMV4=;
  b=Wyo5awPSsA/go4jpwFCuTyHBiNaykEIcnFFA64OlnqA5m7U5XgzLqF4R
   Q845rt5uqYA9Rscc6irH6u+pTNZpKvh3sVZeeM1uFqbEkGM1RiUFGpdyk
   YNwme026m2bq5N8jMmYKEQvImX09mHXi3Xj33PTONrhjxTowQKEwPHJos
   E=;
IronPort-SDR: ABDcDgfik7o+SArl91010WEx/ZF+I96DyX9b3KJ9rsyHxPFwMhFB1u3APGHLNTWllYm+woQLPs
 ty+pH0xLFFsg==
X-IronPort-AV: E=Sophos;i="5.75,458,1589241600"; 
   d="scan'208";a="47070575"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Aug 2020 20:20:14 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id A717DA2788;
        Mon, 10 Aug 2020 20:20:13 +0000 (UTC)
Received: from EX13D01UEB001.ant.amazon.com (10.43.60.34) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:20:13 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D01UEB001.ant.amazon.com (10.43.60.34) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:20:13 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 10 Aug 2020 20:20:12 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id A1B26C13FC; Mon, 10 Aug 2020 20:20:12 +0000 (UTC)
Date:   Mon, 10 Aug 2020 20:20:12 +0000
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <tglx@linutronix.de>
Subject: Re: [PATCH 4.14 1/2] genirq/affinity: Handle affinity setting on
 inactive interrupts correctly
Message-ID: <20200810202012.GA20767@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
References: <20200810201144.20618-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200810201144.20618-1-fllinden@amazon.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Forgot to Cc these to Thomas - let me forward them to ask his input.

Thomas - do these look good to you? 4.14 is a little different in the sense
that it didn't have the x86 set-affinity-before-activate workaround. It
did have the same failure scenario that was seen on arm64, so the patches
are necessary.

The x86 irq allocation loop has some differences for 4.14 x86 too, but
I don't see any problems there.

I tested this backport by running it through our regression tests and
the reproducer case for the original problem.

Thanks,

- Frank
