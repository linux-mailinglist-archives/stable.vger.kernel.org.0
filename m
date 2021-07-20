Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40203CFE9F
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbhGTPZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242664AbhGTPL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 11:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626796319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvbgt8bgFi4UrfnwLKyGLkkhsgSh4h/OpNZ9UZYODgk=;
        b=PlSlq6XyoJ+9k6GI/G7RrlrgaNELWEDRfW8qoQ2R5x3SxM+QbcqRR9Dl+GrcCRELV2cEaB
        V1GFQsqH0hM3vXX2KoX6SYJ0l7jWjJhjw++3r+HG7LPmrXFlBSC1CyVmqBNnc3JWXL+wsN
        AW7VA0cC3AFc2JmwPK8uMXrakXUa6Lg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-k_KHYd1ZPcGNs8ZnsnwKnQ-1; Tue, 20 Jul 2021 11:51:55 -0400
X-MC-Unique: k_KHYd1ZPcGNs8ZnsnwKnQ-1
Received: by mail-qv1-f69.google.com with SMTP id l4-20020a0ce0840000b02902cec39ab618so19683695qvk.5
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 08:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wvbgt8bgFi4UrfnwLKyGLkkhsgSh4h/OpNZ9UZYODgk=;
        b=ND2Q99WJR0Tv9d5442MjvsiEqu1q0nyR/Ei+fXF6gV6id6oF8T/ikr11V5u2e9Fa18
         YhSUZclxhj4z0u2lnafSH9oEBwQrMYvGaj1Ca39Qe0VrxpoKvWAwyFAxFWHVM0LH5oZX
         WS8qyw6cDaCbSqKxM+vjnbOypCtXuGgmMmziRr15cACgqlrP5xQ95/B4Mg3Ze7GgiRZW
         45RoQYjqRJO6DoL+nGpeU1GHZNA/n1jTf+Zkcn2gb5GQay3UpcGtD1uBhlw+esxmOlH0
         C5IantezmFmXzBvGtfTqzvy666JQihr2aihyFGs+k08pm36W1UWD7j5DwzgB/amU88m9
         k3zw==
X-Gm-Message-State: AOAM531f9N9kVEqbW5YzDgzIRe4bKOxR6R5EhCDJqlAQLyFb+oBrJmHJ
        XLr0cQb+Oy5/ErlNCtJ/tzPyLB74/s04dOauFmzsfQkN/FtGzfzUuFTbu/4Rr4+ua9wk7JN61OX
        U3zPlr/pNLE36FlMoT8WlrfvooL/A/GytIdQvBxo+6YdDoqJva3hOqTsN2o5UzG6agw==
X-Received: by 2002:a0c:d644:: with SMTP id e4mr30635666qvj.45.1626796314928;
        Tue, 20 Jul 2021 08:51:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymDLQmLR+blSgDutF8KFkpIvwzykam2LvSQx6L0vHZY/+hXiJy/TeBhG10JKapZoYVDhgeUQ==
X-Received: by 2002:a0c:d644:: with SMTP id e4mr30635629qvj.45.1626796314654;
        Tue, 20 Jul 2021 08:51:54 -0700 (PDT)
Received: from localhost.localdomain (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id c15sm5467012qtc.37.2021.07.20.08.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 08:51:53 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Hillf Danton <hdanton@sina.com>, Igor Raits <igor@gooddata.com>
Subject: [PATCH stable 5.13.y/5.12.y 0/2] mm/thp: Fix uffd-wp with fork(); crash on pmd migration entry on fork
Date:   Tue, 20 Jul 2021 11:51:48 -0400
Message-Id: <20210720155150.497148-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In summary: this series should be needed for 5.10/5.12/5.13. This is the=0D
5.13.y/5.12.y backport of the series, and it should be able to be applied o=
n=0D
both of the branches.  Patch 1 is a dependency of patch 2, while patch 2 sh=
ould=0D
be the real fix.=0D
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

