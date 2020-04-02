Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA0119C80B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389348AbgDBRc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389279AbgDBRc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:32:57 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A94720737;
        Thu,  2 Apr 2020 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848777;
        bh=KxIoRBGSNnE1Ys4N8vXcAxN0RjJ1dPgOqM8vLYkKxLk=;
        h=From:To:Cc:Subject:Date:From;
        b=zseYojfNfNjgJPDQrql24XFDuocPbDveRyPrazCwbMqYQc4S8bT0+eYiUYPqQlTQL
         Qn4pNWGJEMF+/iykTjbLuLaIuKDY7F4dXYwCcaLgbNp4GTlbmAagvBunu21MP4DoCS
         yq4E1k3OgJvNIVL9XdNY0uzGKYwOZCzY6ARJjK14=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        Will Deacon <will@kernel.org>
Subject: [PATCH 0/8] [backports] l2tp use-after-free fixes for 4.4 stable
Date:   Thu,  2 Apr 2020 18:32:42 +0100
Message-Id: <20200402173250.7858-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Syzbot has been complaining about KASAN splats due to use-after-free
issues in the l2tp code on 4.4 Android kernels (although I reproduced
with latest 4.4 stable on my laptop):

https://syzkaller.appspot.com/bug?id=de316389db0fa0cd7ced6e564601ea8e56625ebc

These have been fixed upstream, but for some reason didn't get picked up
for stable. This series applies to 4.4.y and I've sent patches for 4.9
separately.

Thanks,

Will

--->8


Gao Feng (1):
  l2tp: Refactor the codes with existing macros instead of literal
    number

Guillaume Nault (5):
  l2tp: fix race in l2tp_recv_common()
  l2tp: ensure session can't get removed during pppol2tp_session_ioctl()
  l2tp: fix duplicate session creation
  l2tp: ensure sessions are freed after their PPPOL2TP socket
  l2tp: fix race between l2tp_session_delete() and
    l2tp_tunnel_closeall()

Shmulik Ladkani (1):
  net: l2tp: Make l2tp_ip6 namespace aware

phil.turnbull@oracle.com (1):
  l2tp: Correctly return -EBADF from pppol2tp_getname.

 net/l2tp/l2tp_core.c | 149 ++++++++++++++++++++++++++++++++++---------
 net/l2tp/l2tp_core.h |   4 ++
 net/l2tp/l2tp_eth.c  |  10 +--
 net/l2tp/l2tp_ip.c   |  17 +++--
 net/l2tp/l2tp_ip6.c  |  28 +++++---
 net/l2tp/l2tp_ppp.c  | 110 ++++++++++++++++----------------
 6 files changed, 211 insertions(+), 107 deletions(-)

-- 
2.26.0.rc2.310.g2932bb562d-goog

