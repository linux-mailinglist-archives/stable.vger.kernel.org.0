Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A991A1237
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgDGQzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:55:54 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:47916 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgDGQzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:55:54 -0400
Received: by mail-qk1-f201.google.com with SMTP id b21so34532qkl.14
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 09:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yjDKGVlPpnEUO3ADPc9XMgVJd43HWkmb3UWH0/MepjQ=;
        b=JazZJGEVDxWtzbE+rBhv7FUM0fcuY2nthdWsl72LwjAuRSXDtQsvOHhWd7S7BCvACp
         E7icqritJUcVCSJEPi6R71rTKf5tQR1KY8HMmuFej0PTsiaFGH26BNIZE0bZZmgUK+7m
         5A7QMtKJOGNFpG6kJp3KB6S+7kGHq5EGgQoLIK1Z4/sPmkV3qajhkXqWNP11yFjXG336
         35YHQZ8cenvaqZPBTs+QcYDGgXBeUoMMwEqK/0tiD/CyBTBGQkOYEdIHmPaljnBqwCJr
         m/0Ue6ELD0TwAM06/TMCS3JhnZvZ6ieF2UYIeSMY81F6nIVnXIFtTaXfxaVOkOLW9bwk
         PuHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yjDKGVlPpnEUO3ADPc9XMgVJd43HWkmb3UWH0/MepjQ=;
        b=Lg2TgC9BsU6M4jdlVOmamN4dYJQQMBUwGE86tR1y/LlQR1hyKDSQj4MPzO3X/+M22X
         Bv6i8izlfrzh+azUn+QfBkK+uO15mkUaLH23MlOaMgbKQ3nCjiRua1HLmLNkN6BkjULI
         sW/9pOZz5mRxYPoHq4NpvQweN5a4NsvWQhbuf7EAg36blO6RqMSa7DNtF2LmecVk2pok
         zJ+Oj65gubr0NLHQlxnVexBmeg8v/Z29I7CG9rUieWdz4gnLUwJuAGDfV8ysncwueaCr
         rat/t1g8TL3XkCsloAOObfndvoEH/fwqJEcGCbheaI9BZYdPfL4SwW4yUZU/1vf5VTrj
         75zw==
X-Gm-Message-State: AGi0PuZ7buSbxym3kKPn0aZSdeKl6wczPKHEveXab0oeFv4qaHayQnaN
        24Wr+kWjFN0N7zH2Hv14aXuNbZXIpbCuKw==
X-Google-Smtp-Source: APiQypJUMSv/Cr+M38+eoRKa4Wlw7uVmC5EytT6E2smwKPnC04kbKsIPkUZaWKYvMLvHXKOluGfI91T9+itflA==
X-Received: by 2002:a37:4ec1:: with SMTP id c184mr3259717qkb.0.1586278550785;
 Tue, 07 Apr 2020 09:55:50 -0700 (PDT)
Date:   Tue,  7 Apr 2020 17:55:35 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200407165539.161505-1-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH 0/4] backport request for use-after-free blk_mq_queue_tag_busy_iter
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here are the patches for linux-4.4.y. Untested.

Regards,
Giuliano.

Giuliano Procida (4):
  block: more locking around delayed work
  blk-mq: Allow timeouts to run while queue is freezing
  blk-mq: sync things with blk_mq_queue_tag_busy_iter
  blk-mq: Allow blocking queue tag iter callbacks

 block/blk-mq-tag.c  |  7 ++++++-
 block/blk-mq.c      | 17 +++++++++++++++++
 block/blk-timeout.c |  3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

-- 
2.26.0.292.g33ef6b2f38-goog

