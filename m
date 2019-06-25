Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9CA55163
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfFYOR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:17:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46296 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFYOR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 10:17:29 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so27345407edr.13
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 07:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=5MI0Tb2LsOloNKFWvkkspZF859lssQ9DqH94y/jtqm8=;
        b=Ch5w+d+IVGgsKNO8PWLvKs8O9vnsfRUqBA7N5MZfzsq2GBm+1HFJYAo27wpQvFwA0U
         ve0nzfPxdLLEu8KbtyRGg/pqUH4+67kmCL6xVyPXIUypmuuKddR0dGA3oyRy8mr9LeWv
         pNiUptC4s1Af8c4uOqVW72VlfEU6CQ5wJiWfJbVKecEkP0eiRkozViuxwOflFwCb2/4p
         /9dX++o3zgAIxXX3tHwHdngMrRJQuHYWzDNmiQ56mrkHdTTs+d9TsxsqXbM6vPcwt81P
         vqkBSyYbDeNqM78eup2Yf11iuOzDzRfshwnMrGKhu5agehDDdrfUpMTVgq5erSnSopZ+
         vIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=5MI0Tb2LsOloNKFWvkkspZF859lssQ9DqH94y/jtqm8=;
        b=t/CiLVYBvSIcs1Btax/siIWAWuwAC4Ure3SFypXcLeA3JUbfw65WqqaY/1lK9RCL9K
         KD2+Zovwi2HReUL7toYgKlA7vIr7nzf4iM4DaxR6alBkzMBK2Oz+gi5m7dLOgHHOZnhz
         i1kknql1JWuIevMsYrexuVA33HySDQVyS9oWm6ko4uCxfSX5cXEXOq10O0TEyzTjvs4o
         k1lLhA8eFsk2CwJrpdAqouhcO0JNh7inJTqMZ0gHTrD1+eIYFmSgFOdiF3FFpWt4Q7q4
         Hf2slZmkJFb8HcxAePNhKnWlN0Fr7aZAT3NoqgN3lJWaqea/+Jn6SsAhgpMcRmINFznM
         wboQ==
X-Gm-Message-State: APjAAAV7vAM7m4baTukEicvNzMxR9CX/QMcK26Ggn3SsIRu83OvskBgY
        n+rCa6vnrHdFWMsk5f+MACE=
X-Google-Smtp-Source: APXvYqzj8P31Uirjt3728xTpgrzOvqSoLBciIlQz1vGI4qiRm6TN3gk4IMm3t891p/Ca9ZqjlWZLPg==
X-Received: by 2002:a50:9107:: with SMTP id e7mr86960374eda.280.1561472247532;
        Tue, 25 Jun 2019 07:17:27 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id u9sm4917158edm.71.2019.06.25.07.17.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:17:26 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [stable-4.14 0/2] block layer fixes for silent data corruption
Date:   Tue, 25 Jun 2019 16:17:23 +0200
Message-Id: <20190625141725.26220-1-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A silent data corruption was introduced in v4.10-rc1 with commit
72ecad22d9f198aafee64218512e02ffa7818671 and was fixed in v4.18-rc7
with commit 17d51b10d7773e4618bcac64648f30f12d4078fb. It affects
users of O_DIRECT, in our case a KVM virtual machine with drives
which use qemu's "cache=none" option.

The other 2 commits has been accepted in 4.14, but 2 are missing,
ref: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1796542

Please consider to include them in next release.

Thanks,

Jack Wang @ 1 & 1 IONOS Cloud GmbH

Christoph Hellwig (1):
  block: add a lower-level bio_add_page interface

Martin Wilck (1):
  block: bio_iov_iter_get_pages: pin more pages for multi-segment IOs

 block/bio.c         | 131 ++++++++++++++++++++++++++++++++------------
 include/linux/bio.h |   9 +++
 2 files changed, 104 insertions(+), 36 deletions(-)

-- 
2.17.1

