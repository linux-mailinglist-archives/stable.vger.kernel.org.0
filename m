Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADB20F89C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389642AbgF3Pmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:40 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43316 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389638AbgF3Pmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:39 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 0F4B920A539A
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 73CEEBA1D41; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 00/10] Fix possible crash on L2CAP socket shutdown
Date:   Tue, 30 Jun 2020 18:36:31 +0300
Message-ID: <20200630153641.21004-1-d.grigorev@omprussia.ru>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [81.3.167.34]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To LFEX09.lancloud.ru
 (fd00:f066::59)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series of commits fixes a problem with closing l2cap connection
if socket has unACKed frames. Due an to an infinite loop in l2cap_wait_ack
the userspace process gets stuck in close() and then the kernel crashes
with the following report:

Call trace:
[<ffffffc000ace0b4>] l2cap_do_send+0x2c/0xec
[<ffffffc000acf5f8>] l2cap_send_sframe+0x178/0x260
[<ffffffc000acf740>] l2cap_send_rr_or_rnr+0x60/0x84
[<ffffffc000acf980>] l2cap_ack_timeout+0x60/0xac
[<ffffffc0000b35b8>] process_one_work+0x140/0x384
[<ffffffc0000b393c>] worker_thread+0x140/0x4e4
[<ffffffc0000b8c48>] kthread+0xdc/0xf0

All kernels below v4.3 are affected.

-------------------------

Commit log:

Alexey Dobriyan (1):
  Bluetooth: Stop sabotaging list poisoning

Dean Jenkins (8):
  Bluetooth: L2CAP ERTM shutdown protect sk and chan
  Bluetooth: Make __l2cap_wait_ack more efficient
  Bluetooth: Add BT_DBG to l2cap_sock_shutdown()
  Bluetooth: __l2cap_wait_ack() use msecs_to_jiffies()
  Bluetooth: __l2cap_wait_ack() add defensive timeout
  Bluetooth: Unwind l2cap_sock_shutdown()
  Bluetooth: Reorganize mutex lock in l2cap_sock_shutdown()
  Bluetooth: l2cap_disconnection_req priority over shutdown

Tedd Ho-Jeong An (1):
  Bluetooth: Reinitialize the list after deletion for session user list

 include/net/bluetooth/l2cap.h |  2 +
 net/bluetooth/l2cap_core.c    | 12 ++---
 net/bluetooth/l2cap_sock.c    | 94 +++++++++++++++++++++++++++--------
 3 files changed, 78 insertions(+), 30 deletions(-)

-- 
2.17.1

