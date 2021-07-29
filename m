Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0124B3DAB34
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhG2Sor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhG2Sor (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 14:44:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDEFC061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:44:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id j2so9478641edp.11
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 11:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOPZr3jaVxir08R57++rktsm7zNaxG0H/+ArfBt2i6w=;
        b=H9HpiKF2Zjg8VnL7ymPu9midRbhAR3l/zJmYSUwhQqqCPjXaVjdF4VCGNFlE61kmc/
         MNXDYh/P1TWkn43CT+6mr4njp8QFEbErKPHvUVvP8vuykeE9Lqi+0y4pAeRr9m7px6WN
         oGggv9SL3B+ebYdVE5qs3KxgCF0vgPslSBh2KIzW6XFdvKDnL5S2JJdTR8pc/acnWp4I
         0tOVXaQKOfHsC4G7z34rg+6rhSSldw3goca5KhasQef24Mu8szJG66DEYhoh60U0sKgy
         eMdxwVjol+2I8au5hbAEgg1HsXAQKw50PqPI6xAGTF4Du5EjCT0ZERVvKooJYy/fCLgq
         uuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MOPZr3jaVxir08R57++rktsm7zNaxG0H/+ArfBt2i6w=;
        b=ntl7kVORng/0UiYw6H1KWEoM+7S2LdNUB/KN9524dG4juH1+DU8ByVJyIlT5nhfRgb
         YRk4j58Xgb+o343f5DA95754yCnBWBqBf9feOA64B+dhSfkaj13H9wUjl8nnGBIU2YRi
         9lSwXIjbttzCDwyRAItLyttRDUYT8zOPIoHDSxuW9AbgaTJQCeFTFmmrZGBUn5osQpbB
         8su6cGuT0HgAn+1ZIWFmi8Di1fE8eVZz+vniNRE3Cl68mtjjTA0DBgYHIcMZAmi/NLFs
         QoD6tIBrp/sM0PHtloqeGJ4ZmhEKQL6oLKYFCNzULcJS5/ZP587qb1u6eFyyqrXVfem4
         FT3Q==
X-Gm-Message-State: AOAM531bHQpYGr5iT3z4pZ767O564b61JeCMTpnWzniVX6B+hVcKmgb1
        MqTVkWJw24ga9iQIzDdapSc/3RoKPsgoxfxf
X-Google-Smtp-Source: ABdhPJxy0IJLp0lhwA/X2P7iYy/WiHk+MwxxQPQiacROJVYJ+WSI9E2aBAH4Gw9nHn60/hJ7nFCLXg==
X-Received: by 2002:a05:6402:35ca:: with SMTP id z10mr7670805edc.159.1627584282026;
        Thu, 29 Jul 2021 11:44:42 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id l2sm1260057ejg.37.2021.07.29.11.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:44:41 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 4.19 0/2] Backport fixes for 3226b158e67c
Date:   Thu, 29 Jul 2021 20:44:25 +0200
Message-Id: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
introduces a ~10% performance drop when using virtio-net drivers.

This commit has been backported to v4.19 in commit 669c0b5782fb and this
performance drop is also visible there.
Here at Tessares, we can also notice this drop with the MPTCP fork [1]
on top of the v4.19 kernel.

Eric Dumazet already fixed this issue a few months ago, see
commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head").

Unfortunately, this patch has not been backported to < v5.4 because it
caused issues [2]. Indeed, after having backported it, the kernel failed
to compile because one commit was missing, see
commit 503d539a6e41 ("virtio_net: Add XDP meta data support"). However,
this missing commit has been added in 4.19.186 but probably because
there were still some opened discussions [3] around
commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head"),
the latter has not been backported at all in v4.19.

A cherry-pick of this patch without any modification is proposed here.
It has been validated: it fixes the original issue on v4.19 as well.

Please note that there is also a fix for the fix, see
commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment").

This second fix has also not been backported because it caused issues as
well [4]. Here, it was due to a conflict but also a compilation error
when the conflict has been resolved. Please refer to patch 2/2 for more
details.

One last note: these two patches have also been backported and validated
on a v4.14 release. A second series is going to be sent.
It looks like it could be interesting to backport these two patches to
v4.9 and v4.4 as well but unfortunately, the backport of these two
patches fails with conflicts and I don't have any setup to validate the
performance drop and fix with v4.9 and v4.4 kernels.

[1] https://github.com/multipath-tcp/mptcp
[2] https://lore.kernel.org/stable/161806389686151@kroah.com/
[3] https://lore.kernel.org/stable/20210412051204-mutt-send-email-mst@kernel.org/
[4] https://lore.kernel.org/stable/1618749018155126@kroah.com/

Eric Dumazet (2):
  virtio_net: Do not pull payload in skb->head
  gro: ensure frag0 meets IP header alignment

 drivers/net/virtio_net.c   | 10 +++++++---
 include/linux/skbuff.h     |  9 +++++++++
 include/linux/virtio_net.h | 14 +++++++++-----
 net/core/dev.c             |  3 ++-
 4 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.31.1

