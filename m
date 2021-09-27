Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C97419A60
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhI0RIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236233AbhI0RHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D388C610FC;
        Mon, 27 Sep 2021 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762360;
        bh=QcNrbUKzkYUC/UM8/Jd/1yh2RSsTiO4IexvRXWUBn94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6gQEUCfmecKscY+/Mt5LRetVOAGseUKcQc6D2BMP/rppPj46AcvebK0p7hmVCeKv
         UnrL0G/JP0O13uAS7zk9I4VclNw/tVmgxQFo3d1eJivQHLERZNS3BIsy34rRCdvK3O
         zY3YE7RPdewVXW94LZQuQVPeB5bNtczyrH3ff/rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/68] tty: synclink_gt, drop unneeded forward declarations
Date:   Mon, 27 Sep 2021 19:02:30 +0200
Message-Id: <20210927170221.152815058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit b9b90fe655c0bd816847ac1bcbf179cfa2981ecb ]

Forward declarations make the code larger and rewrites harder. Harder as
they are often omitted from global changes. Remove forward declarations
which are not really needed, i.e. the definition of the function is
before its first use.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210302062214.29627-39-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/synclink_gt.c | 57 +--------------------------------------
 1 file changed, 1 insertion(+), 56 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 36f1a4d870eb..4ef84ed54ea5 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -137,37 +137,14 @@ MODULE_PARM_DESC(maxframe, "Maximum frame size used by device (4096 to 65535)");
  */
 static struct tty_driver *serial_driver;
 
-static int  open(struct tty_struct *tty, struct file * filp);
-static void close(struct tty_struct *tty, struct file * filp);
-static void hangup(struct tty_struct *tty);
-static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
-
-static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static int put_char(struct tty_struct *tty, unsigned char ch);
-static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
-static int  write_room(struct tty_struct *tty);
-static void flush_chars(struct tty_struct *tty);
 static void flush_buffer(struct tty_struct *tty);
-static void tx_hold(struct tty_struct *tty);
 static void tx_release(struct tty_struct *tty);
 
-static int  ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg);
-static int  chars_in_buffer(struct tty_struct *tty);
-static void throttle(struct tty_struct * tty);
-static void unthrottle(struct tty_struct * tty);
-static int set_break(struct tty_struct *tty, int break_state);
-
 /*
- * generic HDLC support and callbacks
+ * generic HDLC support
  */
-#if SYNCLINK_GENERIC_HDLC
 #define dev_to_port(D) (dev_to_hdlc(D)->priv)
-static void hdlcdev_tx_done(struct slgt_info *info);
-static void hdlcdev_rx(struct slgt_info *info, char *buf, int size);
-static int  hdlcdev_init(struct slgt_info *info);
-static void hdlcdev_exit(struct slgt_info *info);
-#endif
 
 
 /*
@@ -186,9 +163,6 @@ struct cond_wait {
 	wait_queue_entry_t wait;
 	unsigned int data;
 };
-static void init_cond_wait(struct cond_wait *w, unsigned int data);
-static void add_cond_wait(struct cond_wait **head, struct cond_wait *w);
-static void remove_cond_wait(struct cond_wait **head, struct cond_wait *w);
 static void flush_cond_wait(struct cond_wait **head);
 
 /*
@@ -443,12 +417,8 @@ static void shutdown(struct slgt_info *info);
 static void program_hw(struct slgt_info *info);
 static void change_params(struct slgt_info *info);
 
-static int  register_test(struct slgt_info *info);
-static int  irq_test(struct slgt_info *info);
-static int  loopback_test(struct slgt_info *info);
 static int  adapter_test(struct slgt_info *info);
 
-static void reset_adapter(struct slgt_info *info);
 static void reset_port(struct slgt_info *info);
 static void async_mode(struct slgt_info *info);
 static void sync_mode(struct slgt_info *info);
@@ -457,14 +427,12 @@ static void rx_stop(struct slgt_info *info);
 static void rx_start(struct slgt_info *info);
 static void reset_rbufs(struct slgt_info *info);
 static void free_rbufs(struct slgt_info *info, unsigned int first, unsigned int last);
-static void rdma_reset(struct slgt_info *info);
 static bool rx_get_frame(struct slgt_info *info);
 static bool rx_get_buf(struct slgt_info *info);
 
 static void tx_start(struct slgt_info *info);
 static void tx_stop(struct slgt_info *info);
 static void tx_set_idle(struct slgt_info *info);
-static unsigned int free_tbuf_count(struct slgt_info *info);
 static unsigned int tbuf_bytes(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
@@ -472,26 +440,10 @@ static bool tx_load(struct slgt_info *info, const char *buf, unsigned int count)
 
 static void get_signals(struct slgt_info *info);
 static void set_signals(struct slgt_info *info);
-static void enable_loopback(struct slgt_info *info);
 static void set_rate(struct slgt_info *info, u32 data_rate);
 
-static int  bh_action(struct slgt_info *info);
-static void bh_handler(struct work_struct *work);
 static void bh_transmit(struct slgt_info *info);
-static void isr_serial(struct slgt_info *info);
-static void isr_rdma(struct slgt_info *info);
 static void isr_txeom(struct slgt_info *info, unsigned short status);
-static void isr_tdma(struct slgt_info *info);
-
-static int  alloc_dma_bufs(struct slgt_info *info);
-static void free_dma_bufs(struct slgt_info *info);
-static int  alloc_desc(struct slgt_info *info);
-static void free_desc(struct slgt_info *info);
-static int  alloc_bufs(struct slgt_info *info, struct slgt_desc *bufs, int count);
-static void free_bufs(struct slgt_info *info, struct slgt_desc *bufs, int count);
-
-static int  alloc_tmp_rbuf(struct slgt_info *info);
-static void free_tmp_rbuf(struct slgt_info *info);
 
 static void tx_timeout(struct timer_list *t);
 static void rx_timeout(struct timer_list *t);
@@ -509,10 +461,6 @@ static int  tx_abort(struct slgt_info *info);
 static int  rx_enable(struct slgt_info *info, int enable);
 static int  modem_input_wait(struct slgt_info *info,int arg);
 static int  wait_mgsl_event(struct slgt_info *info, int __user *mask_ptr);
-static int  tiocmget(struct tty_struct *tty);
-static int  tiocmset(struct tty_struct *tty,
-				unsigned int set, unsigned int clear);
-static int set_break(struct tty_struct *tty, int break_state);
 static int  get_interface(struct slgt_info *info, int __user *if_mode);
 static int  set_interface(struct slgt_info *info, int if_mode);
 static int  set_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
@@ -526,9 +474,6 @@ static int  set_xctrl(struct slgt_info *info, int if_mode);
 /*
  * driver functions
  */
-static void add_device(struct slgt_info *info);
-static void device_init(int adapter_num, struct pci_dev *pdev);
-static int  claim_resources(struct slgt_info *info);
 static void release_resources(struct slgt_info *info);
 
 /*
-- 
2.33.0



