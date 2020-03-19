Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEC918B80B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCSNHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgCSNHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD8CD2078A;
        Thu, 19 Mar 2020 13:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623257;
        bh=s3UCQiqRD6ohe6j8S4bXuPj2XzD8bNr8Nh6E+UhN1tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kESzcOEB1rfO/Tx1Sk0yQn7pI8ta6nPVBR6yyLhpomxTpx4THTnjmCRK/1SAtZby0
         2ld627h+yvvOqop6xYnUn4n9r/GIV7O6LvNXRWx4O1YdXjSy6dEADmJK0RzgkmBI4D
         AfPtoQaij5oOMXbxFVtRaRBdZLm5X/D+lojSr8ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 41/93] batman-adv: Avoid endless loop in bat-on-bat netdevice check
Date:   Thu, 19 Mar 2020 13:59:45 +0100
Message-Id: <20200319123938.170029196@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit 1bc4e2b000e7fa9773d6623bc8850561ce10a4fb upstream.

batman-adv checks in different situation if a new device is already on top
of a different batman-adv device. This is done by getting the iflink of a
device and all its parent. It assumes that this iflink is always a parent
device in an acyclic graph. But this assumption is broken by devices like
veth which are actually a pair of two devices linked to each other. The
recursive check would therefore get veth0 when calling dev_get_iflink on
veth1. And it gets veth0 when calling dev_get_iflink with veth1.

Creating a veth pair and loading batman-adv freezes parts of the system

    ip link add veth0 type veth peer name veth1
    modprobe batman-adv

An RCU stall will be detected on the system which cannot be fixed.

    INFO: rcu_sched self-detected stall on CPU
            1: (5264 ticks this GP) idle=3e9/140000000000001/0
    softirq=144683/144686 fqs=5249
             (t=5250 jiffies g=46 c=45 q=43)
    Task dump for CPU 1:
    insmod          R  running task        0   247    245 0x00000008
     ffffffff8151f140 ffffffff8107888e ffff88000fd141c0 ffffffff8151f140
     0000000000000000 ffffffff81552df0 ffffffff8107b420 0000000000000001
     ffff88000e3fa700 ffffffff81540b00 ffffffff8107d667 0000000000000001
    Call Trace:
     <IRQ>  [<ffffffff8107888e>] ? rcu_dump_cpu_stacks+0x7e/0xd0
     [<ffffffff8107b420>] ? rcu_check_callbacks+0x3f0/0x6b0
     [<ffffffff8107d667>] ? hrtimer_run_queues+0x47/0x180
     [<ffffffff8107cf9d>] ? update_process_times+0x2d/0x50
     [<ffffffff810873fb>] ? tick_handle_periodic+0x1b/0x60
     [<ffffffff810290ae>] ? smp_trace_apic_timer_interrupt+0x5e/0x90
     [<ffffffff813bbae2>] ? apic_timer_interrupt+0x82/0x90
     <EOI>  [<ffffffff812c3fd7>] ? __dev_get_by_index+0x37/0x40
     [<ffffffffa0031f3e>] ? batadv_hard_if_event+0xee/0x3a0 [batman_adv]
     [<ffffffff812c5801>] ? register_netdevice_notifier+0x81/0x1a0
    [...]

This can be avoided by checking if two devices are each others parent and
stopping the check in this situation.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
[sven@narfation.org: rewritten description, extracted fix]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -74,6 +74,28 @@ out:
 }
 
 /**
+ * batadv_mutual_parents - check if two devices are each others parent
+ * @dev1: 1st net_device
+ * @dev2: 2nd net_device
+ *
+ * veth devices come in pairs and each is the parent of the other!
+ *
+ * Return: true if the devices are each others parent, otherwise false
+ */
+static bool batadv_mutual_parents(const struct net_device *dev1,
+				  const struct net_device *dev2)
+{
+	int dev1_parent_iflink = dev_get_iflink(dev1);
+	int dev2_parent_iflink = dev_get_iflink(dev2);
+
+	if (!dev1_parent_iflink || !dev2_parent_iflink)
+		return false;
+
+	return (dev1_parent_iflink == dev2->ifindex) &&
+	       (dev2_parent_iflink == dev1->ifindex);
+}
+
+/**
  * batadv_is_on_batman_iface - check if a device is a batman iface descendant
  * @net_dev: the device to check
  *
@@ -108,6 +130,9 @@ static bool batadv_is_on_batman_iface(co
 		return false;
 	}
 
+	if (batadv_mutual_parents(net_dev, parent_dev))
+		return false;
+
 	ret = batadv_is_on_batman_iface(parent_dev);
 
 	return ret;


