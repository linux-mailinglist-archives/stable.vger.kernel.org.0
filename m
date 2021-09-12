Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46996407DBB
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhILOHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 10:07:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbhILOHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 10:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631455594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rnLyluRx1yvPWVXP9r/aIXvYN3Wcw9A5saWWud/56Ik=;
        b=TJqi1huQ9curtwp/Z5+BOn/XVy7C4ItmHBK+f933iCZN/7sbEBAV9uJHzEmiGE1rdRf636
        Uv0Za/iUN2REikcetM5WTOWpiIAB+iRnsdytXgsYUpK4fAEvNX4DRSk9uZdiSk31fmNCmG
        8kBVhH0pDhOIcwtUnctToxzG7qAqMHE=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-sUwdfidLNC6wkc6Ajtzviw-1; Sun, 12 Sep 2021 10:06:32 -0400
X-MC-Unique: sUwdfidLNC6wkc6Ajtzviw-1
Received: by mail-yb1-f197.google.com with SMTP id 83-20020a251956000000b0059948f541cbso9598713ybz.7
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 07:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=rnLyluRx1yvPWVXP9r/aIXvYN3Wcw9A5saWWud/56Ik=;
        b=mbvQgc7LlE7zhlI/nM/mzGWOnEjg8RgebNQ/J2xP7+XTH7XD70fVg0uSuvyRE8Zjg3
         C1zQtj5jv/9/2bsqnKlYbKMf3GBB5LuCGbZgAGrD2+AOlhGDNPrdc9RfohtlrUZIRzgG
         FWdBsGae/KlE+493PhFu45V+T3omvuSWrClG6L26lkcW8SsjN8QOVoq/V/6riMzDuz0X
         IT/qGbm5HM4rSGywAknkpH0gpoiWrEn9TalWMwT5GIdJLYkd+85MeNwAIKMNSBgtYpyI
         ubAJI6E9dRYGsaQCqsJnVXs+4isBVn+QnO5tZFiE4FtYIVzORRStexfPFV/b/xIfrH7W
         9qiA==
X-Gm-Message-State: AOAM532eGjJk7t5d0H85RpcJYxVDv1CwZy241C53pemou/IeEIzWz1k9
        +I2fZxFBdz48JkeBgL10VwuUJsRy8v7HsFkrgChc8s96fEQBO2IVOw7n5wVpP3trPYHpMcrLlzs
        ixWJqXWcCxgqcQpkO4BPbb8Z0rIZA3SpT
X-Received: by 2002:a25:6b4d:: with SMTP id o13mr8876320ybm.241.1631455592144;
        Sun, 12 Sep 2021 07:06:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKnObZrmA4iA8UelzE8o4nhCUwSaoGaZZNw8zNZ/q2hfSOq0GRBPWP6pIhMuEmuoU3tq7gazvml+56ZE6jVVo=
X-Received: by 2002:a25:6b4d:: with SMTP id o13mr8876299ybm.241.1631455591859;
 Sun, 12 Sep 2021 07:06:31 -0700 (PDT)
MIME-Version: 1.0
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Sun, 12 Sep 2021 22:06:20 +0800
Message-ID: <CAHj4cs94pDUfSSfij=ENQxL-2PaGrHJSnhn_mHTC+hqSvPzBTQ@mail.gmail.com>
Subject: [bug report] nvme0n1 node still exists after blktests nvme-tcp/014 on 5.13.16-rc1
To:     Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello
I found this failure on stable 5.13.16-rc1[1] and cannot reproduce it
on 5.14, seems we are missing commit[2] on 5.13.y, could anyone help
check it?

[1]
# nvme_trtype=3Dtcp ./check nvme/014
nvme/014 (flush a NVMeOF block device-backed ns)             [passed]
    runtime  30.745s  ...  22.110s
# lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda       8:0    0 465.8G  0 disk
=E2=94=9C=E2=94=80sda1    8:1    0     1G  0 part /boot
=E2=94=9C=E2=94=80sda2    8:2    0    16G  0 part /mnt/dmtest/data
=E2=94=9C=E2=94=80sda3    8:3    0    15G  0 part /mnt/xfstests/mnt1
=E2=94=9C=E2=94=80sda4    8:4    0     1K  0 part
=E2=94=9C=E2=94=80sda5    8:5    0    15G  0 part /mnt/xfstests/mnt2
=E2=94=9C=E2=94=80sda6    8:6    0   7.9G  0 part [SWAP]
=E2=94=9C=E2=94=80sda7    8:7    0     5G  0 part /mnt/xfstests/logwrites
=E2=94=9C=E2=94=80sda8    8:8    0     1G  0 part /mnt/dmtest/metadata
=E2=94=94=E2=94=80sda9    8:9    0 404.9G  0 part /
zram0   252:0    0     8G  0 disk [SWAP]
nvme0n1 259:3    0     1G  0 disk

[  133.791507] run blktests nvme/014 at 2021-09-12 08:08:17
[  133.908750] loop0: detected capacity change from 0 to 2097152
[  133.927551] nvmet: adding nsid 1 to subsystem blktests-subsystem-1
[  133.942518] nvmet_tcp: enabling port 0 (127.0.0.1:4420)
[  133.977746] nvmet: creating controller 1 for subsystem
blktests-subsystem-1 for NQN
nqn.2014-08.org.nvmexpress:uuid:c4c5023e9bcd4cb5889e9510622eb88c.
[  133.994170] nvme nvme0: creating 4 I/O queues.
[  133.999881] nvme nvme0: mapped 4/0/0 default/read/poll queues.
[  134.008683] nvme nvme0: new ctrl: NQN "blktests-subsystem-1", addr
127.0.0.1:4420
[  151.223049] nvme nvme0: using deprecated NVME_IOCTL_IO_CMD ioctl on
the char device!
[  155.675634] nvme nvme0: Removing ctrl: NQN "blktests-subsystem-1"
[  155.682902] block nvme0n1: no available path - failing I/O
[  155.689137] block nvme0n1: no available path - failing I/O
[  155.695295] Buffer I/O error on dev nvme0n1, logical block 32,
async page read

[2]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D5396fdac56d87d04e75e5068c0c92d33625f51e7
5396fdac56d8 nvme: fix refcounting imbalance when all paths are down


--=20
Best Regards,
  Yi Zhang

