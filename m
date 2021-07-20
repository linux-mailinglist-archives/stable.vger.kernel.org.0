Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684A53CFEA5
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbhGTPZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237681AbhGTPRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 11:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626796623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Lwb/S+J+gslC2Y28b3P4zMlQmindrrr+LZzI9LinPc=;
        b=d4CcEfZiGWpfbK9ozp9WthWqFQvygaQBuevq37gyEfkY8LhowDSn9UaG2prDgPAdRKC3+0
        mvHA/Jl8qfwwPSRwPceWcpL1Qc1ZLj+vX3T9J9v1wtTukQFemdD7H9abSejGaQRQVIhd3O
        7/+Y00B1TFvWPhai32WwndmtqWWX/Lg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-chEAhrASNlqltXeFzR26pg-1; Tue, 20 Jul 2021 11:57:02 -0400
X-MC-Unique: chEAhrASNlqltXeFzR26pg-1
Received: by mail-qk1-f197.google.com with SMTP id c3-20020a37b3030000b02903ad0001a2e8so18851823qkf.3
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 08:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Lwb/S+J+gslC2Y28b3P4zMlQmindrrr+LZzI9LinPc=;
        b=CURVxUnlBhzKHusz9GasbZbmeZTauOtssjunJ2OiP4xUUIi1l2H8c7IDb9CRyOKPiQ
         l/MRuK9D3iLGxyMiT2jS29kX7NDujhDIJgkYdi4BtPB8hwS1qG0xnXBAAMSWYWo23ztH
         tmylHAVVcOG4bFR45w/ydWVZyng1+vZ5/2AzpZneCv7nW+6MZ7BMh/Xh+l/ce3sAHqq4
         uh0+M+xlbC90s6y+k97MY3Ddc6a9ASS6KaxgtI0ujDymlog7D1yAJrDRpQZYzVOOewMh
         YGR9kZlh59XL5/acCiESI0m3+Fw0xuW0yqYvvP6wNEv4BCaL4drwIWXnXLBj9givPAnU
         qV2A==
X-Gm-Message-State: AOAM531zLifdtg3ewlNejPCJIdaUZCkkWhg0p1sLuEreIiP7474fMur2
        0KEmF1HRciuDe/wxbgnxDooJTpj2Myt2CefmS0RhUTEzVta4Ks146X9fEJNWeo8ZI4U903qAJUA
        Eni1XT01RzymkQzc++GoIrrlSSeGUjcOhytb9qIQlxFIvDHYa4y3wFzz4O01Lgb6ZHQ==
X-Received: by 2002:ac8:5ac3:: with SMTP id d3mr27100974qtd.257.1626796621515;
        Tue, 20 Jul 2021 08:57:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE0JZxI8C6H+JP4haDAXSMgAMN5qTlpp01szfWOjLU+DL8S7l+xGlXl6hHUCHSo3cqzozHRQ==
X-Received: by 2002:ac8:5ac3:: with SMTP id d3mr27100943qtd.257.1626796621218;
        Tue, 20 Jul 2021 08:57:01 -0700 (PDT)
Received: from localhost.localdomain (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id 74sm5298585qkh.42.2021.07.20.08.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 08:57:00 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Igor Raits <igor@gooddata.com>, peterx@redhat.com,
        Hillf Danton <hdanton@sina.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH stable 5.10.y 0/2] mm/thp: Fix uffd-wp with fork(); crash on pmd migration entry on fork
Date:   Tue, 20 Jul 2021 11:56:55 -0400
Message-Id: <20210720155657.499127-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In summary, this series should be needed for 5.10/5.12/5.13. This is the 5.=
10.y=0D
backport of the series.  Patch 1 is a dependency of patch 2, while patch 2=
=0D
should be the real fix.=0D
=0D
There's a minor conflict on patch 2 when cherry pick due to not having the =
new=0D
helper called page_needs_cow_for_dma().  It's also mentioned at the entry o=
f=0D
patch 2.=0D
=0D
This series should be able to fix a rare race that mentioned in thread:=0D
=0D
https://lore.kernel.org/linux-mm/796cbb7-5a1c-1ba0-dde5-479aba8224f2@google=
.com/=0D
=0D
This fact wasn't discovered when the fix got proposed and merged, because t=
he=0D
fix was originally about uffd-wp and its fork event.  However it turns out =
that=0D
the problematic commit b569a1760782f3d is also causing crashing on fork() o=
f=0D
pmd migration entries which is even more severe than the original uffd-wp=0D
problem.=0D
=0D
Stable kernels at least on 5.12.y has the crash reproduced, and it's possib=
le=0D
5.13.y and 5.10.y could hit it due to having the problematic commit=0D
b569a1760782f3d but lacking of the uffd-wp fix patch (8f34f1eac382, which i=
s=0D
also patch 2 of this series).=0D
=0D
The pmd entry crash problem was reported by Igor Raits <igor@gooddata.com> =
and=0D
debugged by Hugh Dickins <hughd@google.com>.=0D
=0D
Please review, thanks.=0D
=0D
Peter Xu (2):=0D
  mm/thp: simplify copying of huge zero page pmd when fork=0D
  mm/userfaultfd: fix uffd-wp special cases for fork()=0D
=0D
 include/linux/huge_mm.h |  2 +-=0D
 include/linux/swapops.h |  2 ++=0D
 mm/huge_memory.c        | 36 +++++++++++++++++-------------------=0D
 mm/memory.c             | 25 +++++++++++++------------=0D
 4 files changed, 33 insertions(+), 32 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

