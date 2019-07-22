Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142E270076
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfGVNDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 09:03:17 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:34911 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbfGVNDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 09:03:17 -0400
Received: by mail-ed1-f52.google.com with SMTP id w20so40522999edd.2
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 06:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=pudIo6LJtA9sgYxgbqdAbw7uBDKMYl6GczR7fkAkkWA=;
        b=UGWVhHRQ8A060Y0BKJU4pYUrvB0KXpUE7Vv3CK2K8MwpAVsEFQg1ubIUgdjQN1v1lK
         rTXXDUZIO5InSCdlyU2Jk+Wv2qtDfV1UVGyTGLoestRz4bL9V860f+9cBqSx9LSGOcWn
         5+N6cwHO8u+aYyxA9Rjy28HzoylBbsI0V9cbzQafH7BPDR3QqpNmkmcwZCgUyMJjy7/w
         b8DzpFaOdYkm79pYjkkfattC411AZi0+lKVmGfERjhuaZpj91Zb0BIe31PLx2Dhc7C4A
         ZpU4HIWpHewmO7LWyDBfDA76bLx2Cy8OtvAQn8b9DTFeKS6bdKC3J9C78K/GqxWeThoK
         AkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=pudIo6LJtA9sgYxgbqdAbw7uBDKMYl6GczR7fkAkkWA=;
        b=ix+4hj0SSGRMpx3X4IBA9zYGNOkYuv3zlErsX1uWlYX5k+GvLJciIcKR2dk7apLHJf
         ObddQFtCoMp58aC/1ChV/5AFaFOD/A0rwNqEUCYzYM1FJcRlHgEF+baN9KLkqFB4ArC1
         n03M0dLQiAxwu51OcL0/Oh3xy4o1dPJnkQY6/iLWXCj4QKNZ25X6PMLNTIb+6CEvZKQq
         kgB5bpblcWPGOxOiO32Q8Nf4YwgpzN+U3VwdBDhaWI+6+AldaKNS/t5nc/o08jS7PfjF
         tYC2UZ5LhaVlejvbWogl3r9ladV4zfsicc8q3LJ9G2yQa4CVlAdNrurpiaSktaq9n96B
         XfGQ==
X-Gm-Message-State: APjAAAWurMuJJCq/v2myT5mnqa6/sDBX6qIfgUgKwpZzwRUyNRwxBHvM
        zStKwOxs09T/Ku7Gsl02ERY=
X-Google-Smtp-Source: APXvYqwaI/uVt+NwH63YWBY1rplDatajvRRVMFUHRZL+F9OWmEtG/ql7UOZjUmjx+Qmz/JRn4HlnmA==
X-Received: by 2002:a50:8eea:: with SMTP id x39mr60207150edx.49.1563800595099;
        Mon, 22 Jul 2019 06:03:15 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id v12sm7996085ejj.52.2019.07.22.06.03.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 06:03:14 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [stable-4.19 0/4] CVE-2019-3900 fixes
Date:   Mon, 22 Jul 2019 15:03:09 +0200
Message-Id: <20190722130313.18562-1-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg, hi Sasha,

I noticed the fixes for CVE-2019-3900 are only backported to 4.14.133+,
but not to 4.19, also 5.1, fixes have been included in 5.2.

So I backported to 4.19, only compiles fine, no functional tests.

Please review, and consider to include in next release.

Regards,
Jack Wang 1 & 1 IONOS Cloud GmbH

Jason Wang (4):
  vhost: introduce vhost_exceeds_weight()
  vhost_net: fix possible infinite loop
  vhost: vsock: add weight support
  vhost: scsi: add weight support

 drivers/vhost/net.c   | 41 ++++++++++++++---------------------------
 drivers/vhost/scsi.c  | 15 +++++++++++----
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  5 ++++-
 drivers/vhost/vsock.c | 28 +++++++++++++++++++++-------
 5 files changed, 69 insertions(+), 40 deletions(-)

-- 
2.17.1

